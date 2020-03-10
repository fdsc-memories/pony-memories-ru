/*
trn

Это непосылаемый тип, такой же как ref и box

Его задача - сделать внутри актора

*/

class TrnIllustrator
	let env: Env
	new create(env': Env) =>
		env = env'

	fun apply() =>
		var a: AAATrn = AAATrn
		var b: AAATrn = AAATrn

		// Создание AAATrn с другими ссылочными способностями вполне возможно без recover
		// кроме iso, т.к. к iso trn не приводим
		var c1: AAATrn val = AAATrn
		var c2: AAATrn val = AAATrn
		var c3: AAATrn tag = AAATrn
		var c4: AAATrn box = AAATrn
		var c5: AAATrn ref = AAATrn
		var c6: AAATrn trn = AAATrn
		var c7: AAATrn iso = recover AAATrn end

		// Создание AAATrn с ref
		var d: AAATrn ref = AAATrn

		d.inc()
		d.getX()
		
		var a2: AAATrn box = a
		var a3: AAATrn trn = consume a

		// Как видим выше, trn можно делать только один, как и iso
		// Зато из trn можно создавать сколько угодно неизменяемых box
		// Только одна ссылка в акторе изменяется, остальные - для чтения
		// В других акторах данный объект недоступен

		// По сути, trn - тот же ref, но с одной ссылкой для изменения
		// При этом trn, ref и box всегда работают строго последовательно в одном акторе,
		// поэтому проблем с параллелизмом нет никаких

		a3.inc()
		env.out.print("a2.getX() == " + a2.getX().string())


trait TraitTrn
	fun ref apply()
	fun val read() =>
		None

// Для классов способность ссылок по умолчанию - ref
// Для акторов - tag
// Для примитивов - val
class trn AAATrn
	var x: U64 = 1

	fun ref inc(): U64 =>
		x = x + 1
	
	fun getX(): U64 =>
		x

	// trn здесь обязательно, иначе создаст ref
	new trn create() =>
		None


// По-умолчанию актор создаётся со способностью tag
actor ActorTrn
	var x: U64 = 1

	fun ref w() =>
		x = x + 1

	be y(a: AAATrn iso) =>
		x = x + a.x

	be r(a: TraitTrn val) =>
		a.read()

	be printState(env: Env) =>
		env.out.print("ActorTrn x == " + x.string())
