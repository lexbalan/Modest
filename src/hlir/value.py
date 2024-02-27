######################################################################
#                           HLIR VALUE                               #
######################################################################


from util import nbits_for_num
import hlir.type as type
from hlir.type import *
import foundation



def hlir_value_bad(ti=None):
    return {
        'isa': 'value',
        'kind': 'bad',
        'id': hlir_id('_', ti=ti),
        'type': hlir_type_bad(ti),
        'immutable': False,
        'att': [],
        'ti': ti
    }


def hlir_value_literal(t, imm, ti):
    return {
        'isa': 'value',
        'kind': 'literal',
        'type': t,
        'asset': imm,
        'immutable': False,
        'att': [],
        'nl_end': 0,
        'nl': 0,
        'ti': ti
    }




def hlir_is_value(x):
    return x['isa'] == 'value'


