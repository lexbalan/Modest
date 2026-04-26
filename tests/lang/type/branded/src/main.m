// tests/lang/type/branded/src/main.m

type UserId = @branded Nat32
type GroupId = @branded Nat32
type Temperature = @branded Float64
type Name = @branded *Str8

var uid: UserId = UserId 100
var gid: GroupId = GroupId 200

func getUserId () -> UserId {
	return UserId 42
}

func getGroupId () -> GroupId {
	return GroupId 10
}

func processUser (id: UserId) -> Nat32 {
	return Nat32 id
}

func processTemp (t: Temperature) -> Float64 {
	return Float64 t
}

func main () -> Int32 {
	var u = getUserId()
	var g = getGroupId()
	var raw = processUser(u)
	var t = Temperature 36.6
	var f = processTemp(t)
	return 0
}
