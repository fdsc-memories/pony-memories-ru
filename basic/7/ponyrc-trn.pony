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
/*

		var e: ActorTrn = ActorTrn
		e.y(c1)
		// e.y(c3) // это нельзя, т.к. tag к val не приводится
		// Это можно только с "потреблением" ссылки,
		// т.к. iso-ссылка должна существовать в единственном экземпляре
		a.inc()
		e.y(consume a)

		var b2: AAATrn val = consume b
		var b3: AAATrn val = b2
		e.y(b2)
		e.y(b3)

		e.printState(env)
		
		// Так нельзя
		// can't use a consumed local or field in an expression
		// a.getX()
		// b.getX()
		
		b3.getX()
		// b3.inc() // так нельзя, т.к. val не приводим к ref

		var m1: AAATrn = AAATrn
		// var m2: AAATrn = m1
		// Так нельзя
		// AAATrn iso! is not a subtype of AAATrn iso: iso! is not a subcap of iso
		// Здесь нужно использовать consume, т.к. копировать iso не получится

		// Вот это можно. iso! является алиасом ссылки m1 и приводим к AAATrn tag
		var m2: AAATrn iso! = m1
		var m3: AAATrn tag  = m2


		var k = 
		object iso is TraitTrn
			var x: U64 = 1
			// Здесь iso-ссылка будет неявно приведена к ref, т.е. это можно вызывать из-под iso
			fun ref apply() =>
				x = x + 1
		end

		k()
		var k2: TraitTrn val = consume k
		e.r(k2)
*/

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
