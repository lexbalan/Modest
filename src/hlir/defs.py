
from .types import *


typeUnit = TypeUnit()
typeBool = TypeBool()

typeWord8 = TypeWord(width=8)
typeWord16 = TypeWord(width=16)
typeWord32 = TypeWord(width=32)
typeWord64 = TypeWord(width=64)
typeWord128 = TypeWord(width=128)
typeWord256 = TypeWord(width=256)

typeInt8 = TypeInt(width=8)
typeInt16 = TypeInt(width=16)
typeInt32 = TypeInt(width=32)
typeInt64 = TypeInt(width=64)
typeInt128 = TypeInt(width=128)
typeInt256 = TypeInt(width=256)

typeNat8 = TypeNat(width=8)
typeNat16 = TypeNat(width=16)
typeNat32 = TypeNat(width=32)
typeNat64 = TypeNat(width=64)
typeNat128 = TypeNat(width=128)
typeNat256 = TypeNat(width=256)

typeFloat32 = TypeFloat(width=32)
typeFloat64 = TypeFloat(width=64)

typeChar8 = TypeChar(width=8)
typeChar16 = TypeChar(width=16)
typeChar32 = TypeChar(width=32)

# type Nil = Generic(*Unit)
typeNil = TypePointer(to=typeUnit)
typeNil.generic = True

# type FreePointer = *Unit
typeFreePointer = TypePointer(to=typeUnit)
typeFreePointer.generic = True
# не нужно делать decl тк нет собственного имени у этого типа

typeSysNat = typeNat64
undefinedVolume = ValueUndef(typeSysNat, ti=None)
typeStr8 = TypeArray(typeChar8, undefinedVolume, ti=None)
typeStr8.id = Id('Str8')
typeStr8.id.c = None
#typeStr8.att.append("z-string")

typeStr16 = TypeArray(typeChar16, undefinedVolume, ti=None)
typeStr16.id = Id('Str16')
typeStr16.id.c = None
#typeStr16.att.append("z-string")

typeStr32 = TypeArray(typeChar32, undefinedVolume, ti=None)
typeStr32.id = Id('Str32')
typeStr32.id.c = None
#typeStr32.att.append("z-string")

type__VA_List = TypeVaList()


