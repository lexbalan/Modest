#####################################################################
#                            PARSER                                 #
#####################################################################

import os
from .lexer import Lexer
from error import error, warning, info
from hlir.id import hlir_id


top_level_stoppers = ['type', 'const', 'var', 'func']
func_stoppers = ['let', 'var', 'if', 'while', 'return', 'type']

class Parser:

    def __init__(self):
        self.lex = Lexer()

    def is_end(self):
        if self.tokens[self.ctoken][1] == '':
            return True
        return self.ctoken >= (len(self.tokens) - 1)


    #def is_blank(self, c):
    #    return c == ' ' or c == '\t' or c == '\n'

    def is_comment(self):
        c = self.ctok_class()
        return c in ['comment-line', 'comment-block']


    def skip(self):
        if self.ctoken < (len(self.tokens) - 1):
            self.ctoken = self.ctoken + 1


    def ctok_class(self):
        return self.tokens[self.ctoken][0]


    def ctok(self):
        return self.tokens[self.ctoken][1]


    def getpos(self):
        return self.ctoken


    def setpos(self, pos):
        self.ctoken = pos


    def nextok(self):
        if self.ctoken + 1 > len(self.tokens):
            pass # TODO
        return self.tokens[self.ctoken + 1][1]


    def ti(self):
        assert(len(self.tokens[self.ctoken]) == 3)
        return self.tokens[self.ctoken][2]


    def gettok(self):
        t = self.ctok()
        self.skip()
        return t


    def skip_tokens(self, tokens):
        while self.ctok() in tokens:
            self.skip()


    def look(self, token):
        return self.ctok() == token


    def match(self, token):
        if self.token_class_is('str'):
            return False

        yes = self.look(token)
        if yes:
            self.skip()

        return yes


    def token_class_is(self, clas):
        c = self.ctok_class()
        if c == clas:
            return True
        return False


    def need(self, token):
        ti = self.ti()
        yes = self.match(token)
        if not yes:
            error("expected '%s' token" % token, ti)
        return yes


    def is_assign_operator(self):
        return self.match("<-") or self.match("=") or self.match("=")

    def is_identifier(self):
        return self.ctok_class() == 'id'

    def is_operator(self):
        return self.ctok_class() == 'op'

    def is_tag(self):
        return self.ctok_class() == 'tag'

    def identifier(self):
        ti = self.ti()
        if not self.is_identifier():
            self.skip()
            error("expected identifier", ti)
            return None
        s = self.gettok()
        return hlir_id(s, ti=ti)


    def need_sep(self, separators=['\n', ';'], stoppers=['}'], eat=True):
        # random space after
        self.skip_tokens([' ', '\t'])

        if self.ctok() in separators:
            if eat:
                while self.ctok() in separators:
                    self.skip()

        elif self.ctok() in stoppers:
            pass
        elif self.ctok_class() in ['comment-line', 'comment-block']:
            self.skip()
            pass
        else:
            error("expected separator", self.ti())
            self.restore(top_level_stoppers + func_stoppers)
            return False

        return True

    #
    # Parse Type
    #

    def expr_type_record(self, ti):
        self.need("{")
        fields = []

        spaceline_cnt = 0

        while True:

            #self.skip_tokens([' ', '\t', '\n'])

            comments = []
            directives = []

            spaceline_cnt = 0

            # skip spaces & comments before
            while True:
                if self.match('\n'):
                    spaceline_cnt = spaceline_cnt + 1
                    continue
                elif self.token_class_is('comment-block'):
                    x = self.parse_comment_block()
                    x['nl'] = spaceline_cnt
                    spaceline_cnt = 0
                    comments.append(x)
                elif self.token_class_is('comment-line'):
                    x = self.parse_comment_line()
                    x['nl'] = spaceline_cnt
                    spaceline_cnt = 0
                    comments.append(x)
                elif self.token_class_is('directive'):
                    x = self.parse_directive()
                    x['nl'] = spaceline_cnt
                    spaceline_cnt = 0
                    directives.append(x)


                elif self.match(","):
                    pass
                elif self.match(";"):
                    pass
                else:
                    break

            if self.match("}"):
                break

            f = self.parse_field()

            self.need_sep(separators=['\n', ',', ';'], eat=False)

            if f != None:
                f[0].update({'comments': comments})
                f[0].update({'directives': directives})
                f[0]['nl'] = spaceline_cnt
                spaceline_cnt = 0
                fields.extend(f)

        return {
            'isa': 'type',
            'kind': 'record',
            'fields': fields,
            'end_nl': spaceline_cnt,
            'ti': ti
        }



    def check_is_field(self):
        if self.is_identifier():
            token = self.gettok()
            if not token[0].islower():
                return False
            if not self.match(':'):
                return False

            return True


    def check_is_type(self):
        if self.is_identifier():
            token = self.gettok()
            if token[0].isupper():
                return True
            return token in ['record', 'enum']

        elif self.is_operator():
            token = self.gettok()
            if token == '*':
                # maybe it is pointer? (or it's 'deref' operation)
                return self.is_type_expr()

            elif token == '[':
                # maybe it is array?
                while not self.match(']'):
                    self.skip()
                return self.is_type_expr()

            elif token == '(':
                #print("ok")
                # is ` ( <#type_expr#> ) ` ?
                if self.is_type_expr():
                    return self.match(')')

                if self.match(")"):
                    return self.match("->") or self.match("{")

                # maybe it's func?
                if not self.match(")"):
                    if self.check_is_field():
                        return True

                return False

            return False

        else:
            return False

        return False



    def is_type_expr(self):
        pos = self.getpos()            # save position
        result = self.check_is_type()  # check
        self.setpos(pos)               # restore position
        return result

    def is_value_expr(self):
        pos = self.getpos()                # save position
        result = not self.check_is_type()  # check
        self.setpos(pos)                   # restore position
        return result


    def expr_type(self):
        ti = self.ti()

        if not self.is_type_expr():
            error("expected type expr", ti)
            return None

        if self.match("("):
            fields = []
            while not self.match(")"):
                f = self.parse_field()
                self.match(",")
                if f != None:
                    fields.extend(f)

            if self.match("->"):
                t = self.expr_type()
                return {
                    'isa': 'type',
                    'kind': 'func',
                    'params': fields,
                    'to': t,
                    'ti': ti
                }
            else:
                return {
                    'isa': 'type',
                    'kind': 'func',
                    'params': fields,
                    'to': None,
                    'size': 0,
                    'align': 0,
                    'ti': ti
                }
            #    return r

        elif self.match("*"):
            t = self.expr_type()
            return {'isa': 'type', 'kind': 'pointer', 'to': t, 'ti': ti}

        elif self.match("record"):
            return self.expr_type_record(ti)


        elif self.match("enum"):
            self.need("{")
            items = []
            while not self.match("}"):
                self.skip_tokens([' ', '\t', '\n'])
                ti = self.ti()
                id = self.identifier()
                self.need_sep(separators=['\n', ','])
                items.append({'id': id, 'ti': ti})
            return {'isa': 'type', 'kind': 'enum', 'items': items, 'ti': ti}

        elif self.match("["):
            y = {'isa': 'type', 'kind': 'array', 'size': None, 'ti': ti}
            s = None
            if not self.match("]"):
                y['size'] = self.expr_value()
                self.need("]")
            y['of'] = self.expr_type()
            return y

        elif self.ctok_class() == 'id':
            id = self.identifier() # type by Name
            return {'isa': 'type', 'kind': 'id', 'id': id, 'ti': ti}


    #
    # Parse Value
    #

    def expr_value(self):
        return self.expr_value_1()


    def expr_value_1(self):
        v = self.expr_value_2()
        ti = self.ti()
        if self.match("or"):
            r = self.expr_value()
            ti['start'] = v['ti']
            ti['end'] = r['ti']
            return {'isa': 'value', 'kind': 'or', 'left': v, 'right': r, 'ti': ti}
        else:
            return v


    def expr_value_2(self):
        v = self.expr_value_3()
        ti = self.ti()
        if self.match("xor"):
            r = self.expr_value_2()
            ti['start'] = v['ti']
            ti['end'] = r['ti']
            return {'isa': 'value', 'kind': 'xor', 'left': v, 'right': r, 'ti': ti}
        else:
            return v


    def expr_value_3(self):
        v = self.expr_value_4()
        ti = self.ti()
        if self.match("and"):
            r = self.expr_value_3()
            ti['start'] = v['ti']
            ti['end'] = r['ti']
            return {'isa': 'value', 'kind': 'and', 'left': v, 'right': r, 'ti': ti}
        else:
            return v


    def expr_value_4(self):
        v = self.expr_value_5()
        while True:
            ti = self.ti()
            if self.match("=="):
                r = self.expr_value_5()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'eq', 'left': v, 'right': r, 'ti': ti}
            elif self.match("!="):
                r = self.expr_value_5()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'ne', 'left': v, 'right': r, 'ti': ti}
            else:
                break
        return v


    def expr_value_5(self):
        v = self.expr_value_6()
        while True:
            ti = self.ti()
            if self.match("<"):
                r = self.expr_value_6()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'lt', 'left': v, 'right': r, 'ti': ti}
            elif self.match(">"):
                r = self.expr_value_6()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'gt', 'left': v, 'right': r, 'ti': ti}
            if self.match("<="):
                r = self.expr_value_6()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'le', 'left': v, 'right': r, 'ti': ti}
            elif self.match(">="):
                r = self.expr_value_6()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'ge', 'left': v, 'right': r, 'ti': ti}
            else:
                break
        return v


    def expr_value_6(self):
        v = self.expr_value_7()
        while True:
            ti = self.ti()
            if self.match("<<"):
                l = v
                r = self.expr_value_7()
                ti['start'] = l['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'shl', 'left': v, 'right': r, 'ti': ti}
            elif self.match(">>"):
                l = v
                r = self.expr_value_7()
                ti['start'] = l['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'shr', 'left': v, 'right': r, 'ti': ti}
            else:
                break
        return v


    def expr_value_7(self):
        v = self.expr_value_8()
        while True:
            ti = self.ti()
            if self.match("+"):
                r = self.expr_value_8()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'add', 'left': v, 'right': r, 'ti': ti}
            elif self.match("-"):
                r = self.expr_value_8()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'sub', 'left': v, 'right': r, 'ti': ti}
            else:
                break
        return v


    def expr_value_8(self):
        v = self.expr_value_9()
        while True:
            ti = self.ti()
            if self.match("*"):
                r = self.expr_value_9()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'mul', 'left': v, 'right': r, 'ti': ti}
            elif self.match("/"):
                r = self.expr_value_9()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'div', 'left': v, 'right': r, 'ti': ti}
            elif self.match("%"):
                r = self.expr_value_9()
                ti['start'] = v['ti']
                ti['end'] = r['ti']
                v = {'isa': 'value', 'kind': 'rem', 'left': v, 'right': r, 'ti': ti}
            else:
                break
        return v


    # cons
    def expr_value_9(self):
        if self.is_type_expr():
            ti = self.ti()
            t = self.expr_type()
            v = self.expr_value_9()
            return {
                'isa': 'value',
                'kind': 'cons',
                'value': v,
                'type': t,
                'ti': ti
            }

        else:
            return self.expr_value_10()



    def expr_value_10(self):
        ti = self.ti()
        if self.match("*"):
            v = self.expr_value_10()
            ti['end'] = v['ti']
            return {'isa': 'value', 'kind': 'deref', 'value': v, 'ti': ti}
        elif self.match("&"):
            v = self.expr_value_11()
            ti['end'] = v['ti']
            return {'isa': 'value', 'kind': 'ref', 'value': v, 'ti': ti}
        elif self.match("not"):
            v = self.expr_value_11()
            ti['end'] = v['ti']
            return {'isa': 'value', 'kind': 'not', 'value': v, 'ti': ti}
        elif self.match("+"):
            v = self.expr_value_11()
            ti['end'] = v['ti']
            return {'isa': 'value', 'kind': 'positive', 'value': v, 'ti': ti}
        elif self.match("-"):
            v = self.expr_value_11()
            ti['end'] = v['ti']
            return {'isa': 'value', 'kind': 'negative', 'value': v, 'ti': ti}
        elif self.match("sizeof"):
            self.match("(")
            t = self.expr_type()
            self.need(")")
            return {'isa': 'value', 'kind': 'sizeof', 'type': t, 'ti': ti}
        elif self.match("alignof"):
            self.match("(")
            t = self.expr_type()
            self.need(")")
            return {'isa': 'value', 'kind': 'alignof', 'type': t, 'ti': ti}
        elif self.match("offsetof"):
            self.match("(")
            t = self.expr_type()
            self.need('.')
            f = self.identifier()
            self.need(")")
            return {'isa': 'value', 'kind': 'offsetof', 'type': t, 'field': f, 'ti': ti}
        else:
            y = self.expr_value_11()
            return y


    def expr_value_11(self):
        v = self.expr_value_term()
        while True:
            ti = self.ti()
            if self.match("("):
                args = []
                while not self.match(")"):
                    self.skip_tokens([' ', '\t', '\n'])
                    a = self.expr_value()
                    args.append(a)
                    self.need_sep(separators=[',', '\n'], stoppers=[')'])

                v = {
                    'isa': 'value',
                    'kind': 'call',
                    'left': v,
                    'args': args,
                    'ti': ti
                }
            elif self.match("."):
                field_id = self.identifier()
                ti['start'] = v['ti']
                ti['end'] = field_id['ti']

                v = {
                    'isa': 'value',
                    'kind': 'access',
                    'left': v,
                    'field': field_id,
                    'ti': ti
                }
            #elif self.look("[") and self.is_value_expr():
            elif self.match("["):
                #self.skip()  # "[":
                i = self.expr_value()
                self.need("]")
                ti['start'] = v['ti']
                #ti['end'] =
                v = {
                    'isa': 'value',
                    'kind': 'index',
                    'left': v,
                    'index': i,
                    'ti': ti
                }
            else:
                return v



    def parse_value_array(self, ti):
        items = []

        nl_cnt = 0
        ti = self.ti()
        self.need("[")
        while not self.match("]"):
            #self.skip_tokens([' ', '\t', '\n'])
            nl_cnt = self.skip_blanks()

            while True:
                if self.token_class_is('comment-block'):
                    x = self.parse_comment_block()
                elif self.token_class_is('comment-line'):
                    x = self.parse_comment_line()
                else:
                    break

                # append comment to array 'items' list
                items.append(x)

            nl_cnt = nl_cnt + self.skip_blanks()

            if self.match("]"):
                break

            field_value = self.expr_value()
            field_value['nl'] = nl_cnt
            #field_value['comments'] = comments

            if not self.look("\n"):
                self.need_sep(separators=[','], stoppers=[']'])

            items.append(field_value)

        return {
            'isa': 'value',
            'kind': 'array',
            'items': items,
            'nl_end': nl_cnt,
            'ti': ti
        }


    def parse_value_record(self, ti):
        items = []

        nl_cnt = 0
        ti = self.ti()
        self.need("{")
        while not self.match("}"):
            #self.skip_tokens([' ', '\t', '\n'])
            nl_cnt = self.skip_blanks()

            while True:
                if self.token_class_is('comment-block'):
                    x = self.parse_comment_block()
                elif self.token_class_is('comment-line'):
                    x = self.parse_comment_line()
                else:
                    break

                # append comment to record 'items' list
                items.append(x)


            nl_cnt = nl_cnt + self.skip_blanks()

            if self.match("}"):
                break

            item_ti = self.ti()
            field_id = self.identifier()
            self.need("=")
            field_value = self.expr_value()
            if not self.look("\n"):
                self.need_sep(separators=[',', '\n'], stoppers=['}'])

            items.append({
                'isa': 'item',
                'id': field_id,
                'value': field_value,
                'nl': nl_cnt,
                'ti': item_ti
            })

        return {
            'isa': 'value',
            'kind': 'record',
            'items': items,
            'nl_end': nl_cnt,
            'ti': ti
        }


    def parse_value_string(self, s, ti):
            str_len = 0
            new_s = ''
            i = 0
            while i < len(s):
                sym = s[i]

                if sym == '\\':
                    code = 0

                    # nexsym
                    i = i + 1
                    sym = s[i]

                    if sym == '{':
                        # eat "\{" as is
                        new_s = new_s + '\\{'
                        continue
                    elif sym == '}':
                        # eat "\}" as is
                        new_s = new_s + '\\}'
                        continue
                    elif sym == '"':
                        # eat "\""
                        new_s = new_s + sym
                        str_len = str_len + 1
                        i = i + 1
                        continue

                    # '\xCODE' ?
                    is_num = sym.isdigit()
                    is_hex = sym == 'x'

                    if is_num or is_hex:
                        asciicode = ''

                        if is_hex:
                            i = i + 1
                            sym = s[i]
                            asciicode = '0x'

                        hexsyms = [
                            'a', 'b', 'c', 'd', 'e', 'f',
                            'A', 'B', 'C', 'D', 'E', 'F',
                        ]
                        while True:
                            asciicode = asciicode + sym
                            if i == len(s) - 1:
                                break
                            i = i + 1
                            sym = s[i]
                            if not sym.isdigit() or (is_hex and sym in hexsyms):
                                i = i - 1
                                break

                        base = 10
                        if is_hex:
                            base = 16

                        code = int(asciicode, base)

                    elif sym == 't':
                        code = 9
                    elif sym == 'n':
                        code = 10
                    elif sym == 'r':
                        code = 13
                    elif sym == '"':
                        code = '34'
                    elif sym == '\\':
                        code = 92

                    sym = chr(code)

                new_s = new_s + sym
                str_len = str_len + 1
                i = i + 1

            str_len = str_len + 1
            string = ''.join(new_s)

            return {
                'isa': 'value',
                'kind': 'str',
                'len': str_len,
                'str': string,
                'ti': ti
            }




    def expr_value_term(self):
        ti = self.ti()

        if self.match("("):
            v = self.expr_value()
            self.need(")")
            v['ti'] = ti
            return v

        elif self.ctok_class() == 'id':
            id = self.identifier()

            if self.match("::"):
                id2 = self.identifier()
                return {'isa': 'value', 'kind': 'ns', 'ids': [id, id2], 'ti': ti}

            #if id['str'][0].islower():
            return {'isa': 'value', 'kind': 'id', 'id': id, 'ti': ti}
            #else:
            #    return {'isa': 'value', 'kind': 'id', 'id': id, 'ti': ti}

        elif self.ctok_class() == 'num':
            numstr = self.gettok()
            return {
                'isa': 'value',
                'kind': 'number',
                'numstr': numstr,
                'att': [],
                'ti': ti
            }

        elif self.ctok_class() == 'str':
            s = self.gettok()
            return self.parse_value_string(s, ti)

        elif self.ctok_class() == 'tag':
            num = self.gettok()
            return {'isa': 'value', 'kind': 'tag', 'tag': num, 'ti': ti}

        elif self.look("["):
            return self.parse_value_array(ti)

        elif self.look("{"):
            return self.parse_value_record(ti)

        else:
            cl = self.ctok_class()
            tokstr = self.ctok()

            if tokstr == '\n':
                tokstr = 'newline'
            elif tokstr == '':
                tokstr = 'end-of-file'

            error("unexpected token '%s'" % tokstr, self.ti())
            self.skip()
            return {'isa': 'value', 'kind': 'bad', 'ti': ti}



    #
    # Parse Statement
    #

    def stmt_let(self):
        id = self.identifier()
        self.need("=")
        r = self.expr_value()
        return {'isa': 'stmt', 'kind': 'let', 'id': id, 'value': r}

    def stmt_if(self):
        c = self.expr_value()
        t = self.stmt_block()
        e = None
        if self.match('else'):
            ti = self.ti()
            if self.match('if'):
                e = self.stmt_if()
            else:
                e = self.stmt_block()
            e['ti'] = ti
        return {'isa': 'stmt', 'kind': 'if', 'cond': c, 'then': t, 'else': e}


    def stmt_while(self):
        v = self.expr_value()
        b = self.stmt_block()
        return {'isa': 'stmt', 'kind': 'while', 'cond': v, 'stmt': b}


    def stmt_return(self):
        self.skip()    # skip 'return' keyword

        v = None
        if not (self.look("\n") or self.look(";") or self.look("}")):
            v = self.expr_value()

        return {'isa': 'stmt', 'kind': 'return', 'value': v}


    def stmt_var(self):
        ti = self.ti()

        ids = []
        while True:
            id = self.identifier()
            ids.append(id)
            if not self.match(','):
                break

        t = None
        v = None
        if self.match(":"):
            t = self.expr_type()
        if self.is_assign_operator():
            v = self.expr_value()

        stmts = []
        for id in ids:
            stmt_var = {
                'isa': 'stmt',
                'kind': 'var',
                'id': id,
                'type': t,
                'value': v,
                'ti': id['ti']
            }
            stmts.append(stmt_var)
        return stmts


    def stmt_again(self):
        return {'isa': 'stmt', 'kind': 'again'}


    def stmt_break(self):
        return {'isa': 'stmt', 'kind': 'break'}


    def stmt_inc(self):
        v = self.expr_value()
        return {'isa': 'stmt', 'kind': 'inc', 'value': v}


    def stmt_dec(self):
        v = self.expr_value()
        return {'isa': 'stmt', 'kind': 'dec', 'value': v}


    def stmt_expr_value(self):
        v = self.expr_value()

        # stmt expr
        assign_ti = self.ti()
        if not (self.is_assign_operator()):
            return {'isa': 'stmt', 'kind': 'value', 'value': v}

        # stmt assign
        r = self.expr_value()
        return {'isa': 'stmt', 'kind': 'assign', 'left': v, 'right': r, 'ti': assign_ti}


    def stmt_comment_line(self):
        ti = self.ti()
        x = self.gettok()
        return {'isa': 'stmt', 'kind': 'comment-line', 'lines': x, 'ti': ti}


    def stmt_comment_block(self):
        ti = self.ti()
        x = self.gettok()
        return {'isa': 'stmt', 'kind': 'comment-block', 'text': x, 'ti': ti}


    def stmt(self):
        ti = self.ti()

        if self.match('let'):
            s = self.stmt_let()
        elif self.match('if'):
            s = self.stmt_if()
        elif self.match('while'):
            s = self.stmt_while()
        elif self.look('return'):
            s = self.stmt_return()
        elif self.match('var'):
            s = self.stmt_var()
        elif self.match('again'):
            s = self.stmt_again()
        elif self.match('break'):
            s = self.stmt_break()
        elif self.match('const'):
            s = self.stmt_let()
        elif self.match('++'):
            s = self.stmt_inc()
        elif self.match('--'):
            s = self.stmt_dec()
        else:

            # comment?
            cl = self.ctok_class()
            if cl == 'comment-line':
                s = self.stmt_comment_line()
            elif cl == 'comment-block':
                s = self.stmt_comment_block()
            else:
                s = self.stmt_expr_value()

        if s == None:
            return s

        # переменные могут быть объявлены списком
        if isinstance(s, list):
            return s

        if not 'ti' in s:
            s['ti'] = ti

        return s


    def skip_blanks(self):
        nl_cnt = 0
        while True:
            if self.look(" ") or self.look("\t"):
                self.skip()
                continue

            elif self.look('\n'):
                self.skip()
                nl_cnt = nl_cnt + 1
                continue

            else:
                return nl_cnt


    def stmt_block(self):
        ti = self.ti()
        #print('stmt_block')

        nl_cnt = 0
        self.need("{")
        stmts = []
        while True:
            #self.skip_tokens([' ', '\t', '\n'])

            nl_cnt = self.skip_blanks()


            if self.match('}'):
                break

            s = self.stmt()

            if s != None:
                sep = self.need_sep(eat=False)

                while self.match(";"):
                    pass
                #if sep == False:
                #    break

                if isinstance(s, list):
                    s[0]['nl'] = nl_cnt
                    stmts.extend(s)
                else:
                    s['nl'] = nl_cnt
                    stmts.append(s)

                nl_cnt = 0

        return {
            'isa': 'stmt',
            'kind': 'block',
            'stmts': stmts,
            'end_nl': nl_cnt,
            'ti': ti
        }


    def parse_field(self):
        ti = self.ti()

        objs = []
        while True:
            nl_cnt = 0

            comments_and_directives = []
            while True:
                nl_cnt = self.skip_blanks()

                if self.is_identifier():
                    break

                x = None
                if self.token_class_is('comment-block'):
                    x = self.parse_comment_block()
                    comments_and_directives.append(x)
                elif self.token_class_is('comment-line'):
                    x = self.parse_comment_line()
                    comments_and_directives.append(x)
                elif self.token_class_is('directive'):
                    x = self.parse_directive()
                    comments_and_directives.append(x)

                if x != None:
                    x['nl'] = nl_cnt


            id = self.identifier()
            if id == None:
                break

            objs.append({
                'id': id,
                'comments_and_directives': comments_and_directives
            })

            if self.match(','):
                self.skip_tokens(["\n"])
                continue

            break

        if objs == []:
            self.restore(['\n', ','])
            return None

        if not self.need(":"):
            self.restore(['\n', ','])
            return None

        t = self.expr_type()

        fields = []
        for obj in objs:
            id = obj['id']
            field = {
                'isa': 'field',
                'id': id,
                'type': t,
                'comments_and_directives': obj['comments_and_directives'],
                'ti': id['ti']
            }
            fields.append(field)

        return fields


    #
    # Top Level Directives
    #

    def parse_import(self):
        ti = self.ti()

        if not self.look("{"):
            import_expr = self.expr_value()
            return {
                'isa': 'ast_directive',
                'kind': 'import',
                'expr': import_expr,
                'ti': ti
            }
        else:

            imports = []
            self.skip()  # {
            while True:
                nl_cnt = self.skip_blanks()

                if self.match('}'):
                    break

                import_expr = self.expr_value()
                import_dir = {
                    'isa': 'ast_directive',
                    'kind': 'import',
                    'expr': import_expr,
                    'ti': ti
                }

                imports.append(import_dir)

            return imports



    def parse_def_func(self):
        ti = self.ti()
        id = self.identifier()
        ftyp = self.expr_type()

        if self.is_comment():
            self.skip()

        # func declaration?
        if self.look("\n"):
            return {
                'isa': 'ast_declaration',
                'kind': 'func',
                'id': id,
                'type': ftyp,
                'ti': ti
            }

        # func definition
        s = self.stmt_block()
        return {
            'isa': 'ast_definition',
            'kind': 'func',
            'id': id,
            'type': ftyp,
            'stmt': s,
            'ti': ti
        }


    def parse_def_const(self):
        ti = self.ti()
        id = self.identifier()
        self.need('=')
        v = self.expr_value()
        return {
            'isa': 'ast_definition',
            'kind': 'const',
            'id': id,
            'value': v,
            'ti': ti
        }


    def parse_def_var(self):
        ff = self.parse_field()
        if ff == None:
            return None

        iv = None
        if self.is_assign_operator():
            iv = self.expr_value()

        vars = []
        for f in ff:
            vars.append({
                'isa': 'ast_definition',
                'kind': 'var',
                'field': f,
                'init': iv,
                'ti': f['ti']
            })

        return vars


    def parse_def_type(self):
        ti = self.ti()
        id = self.identifier()

        if self.is_comment():
            self.skip()

        # type declaration
        if self.look("\n"):
            return {
                'isa': 'ast_declaration',
                'kind': 'type',
                'id': id,
                'ti': ti
            }

        # type definition
        t = self.expr_type()
        return {
            'isa': 'ast_definition',
            'kind': 'type',
            'id': id,
            'type': t,
            'ti': ti
        }


    def restore_top_level(self):
        while not self.is_end():
            token_str = self.ctok()
            if token_str in ['func', 'const', 'var', 'type', 'exist', 'extern']:
                break
            self.skip()


    def parse_comment_line(self):
        ti = self.ti()
        x = self.gettok()
        return {'isa': 'ast_comment', 'kind': 'line', 'lines': x, 'ti': ti}


    def parse_comment_block(self):
        ti = self.ti()
        x = self.gettok()
        return {'isa': 'ast_comment', 'kind': 'block', 'text': x, 'ti': ti}



    def parse_directive(self):
        ti = self.ti()
        x = self.gettok()

        dir = {
            'isa': 'ast_directive',
            'kind': 'directive',
            'text': x,
            'ti': ti
        }

        if x == 'if':
            c = self.expr_value()
            dir['kind'] = 'if'
            dir['cond'] = c
        elif x == 'elseif':
            c = self.expr_value()
            dir['kind'] = 'elseif'
            dir['cond'] = c
        elif x == 'else':
            dir['kind'] = 'else'
        elif x == 'endif':
            dir['kind'] = 'endif'
        elif x == 'info':
            v = self.expr_value()
            dir['kind'] = 'info'
            dir['value'] = v
        elif x == 'warning':
            v = self.expr_value()
            dir['kind'] = 'warning'
            dir['value'] = v
        elif x == 'error':
            v = self.expr_value()
            dir['kind'] = 'error'
            dir['value'] = v
        #elif x == 'pragma':
        #    dir['kind'] = 'pragma'


        return dir



    def parse(self, source_info):

        self.tokens = self.lex.run(source_info['path'])
        self.ctoken = 0

        output = []

        spaceline_cnt = 0
        while not self.is_end():
            x = None
            ti = self.ti()
            if self.match('\n'):
                spaceline_cnt = spaceline_cnt + 1
                continue
            elif self.token_class_is('comment-block'):
                x = self.parse_comment_block()
            elif self.token_class_is('comment-line'):
                x = self.parse_comment_line()
            elif self.token_class_is('directive'):
                x = self.parse_directive()

            # we can do const definition before import?
            elif self.match('const') or self.match('let'):
                x = self.parse_def_const()

            elif self.match('import'):
                x = self.parse_import()

            if x == None:
                break

            if isinstance(x, list):
                x[0]['nl'] = spaceline_cnt
                # у остальных #nl = 1 (!)
                for xx in x[1:]:
                    xx['nl'] = 1

                spaceline_cnt = 0
                output.extend(x)
            else:

                x['nl'] = spaceline_cnt
                spaceline_cnt = 0

                output.append(x)


        while not self.is_end():
            #export = self.match('export')
            #extern = self.match('extern')

            ti = self.ti()

            x = None

            if self.match('\n'):
                spaceline_cnt = spaceline_cnt + 1
                continue
            elif self.match('func'): x = self.parse_def_func()
            elif self.match('const'): x = self.parse_def_const()
            elif self.match('let'): x = self.parse_def_const()
            elif self.match('var'): x = self.parse_def_var()
            elif self.match('type'): x = self.parse_def_type()

            elif self.token_class_is('comment-block'):
                x = self.parse_comment_block()
            elif self.token_class_is('comment-line'):
                x = self.parse_comment_line()
            elif self.token_class_is('directive'):
                x = self.parse_directive()

            elif self.match('import'):
                warning("import directive must be placed before definitions", ti)
                x = self.parse_import()

            else:
                error("unexpected token %s" % self.ctok(), self.ti())
                self.restore_top_level()
                continue

            if x == None:
                continue

            if isinstance(x, list):

                for subx in x:
                    subx['nl'] = 1
                    subx['ti'] = ti

                x[0]['nl'] = spaceline_cnt

                output.extend(x)
                spaceline_cnt = 0
            else:
                x['nl'] = spaceline_cnt
                x['ti'] = ti


                # тк CM директива не печатается в C
                if x['isa'] == 'ast_directive':
                    spaceline_cnt = spaceline_cnt - 1
                else:
                    spaceline_cnt = 0

                output.append(x)

            #spaceline_cnt = 0


        return output



    def restore(self, stoppers):
        while not self.ctok() in stoppers:
            if self.ctok() == '':
                return
            self.skip()

