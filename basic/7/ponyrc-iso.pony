/*
Iso

Ссылка на объект iso только одна, то есть другой ссылки на этот объект нет
Если нужно передать её другому актору, придётся использовать consume
С этой ссылкой можно делать всё, что угодно, как и с ref, но только не копировать

Копирование возможно только в тип iso!, который может быть преобразован в тип tag
*/

class IsoIllustrator
	let env: Env
	new create(env': Env) =>
		env = env'

	fun apply() =>
		var a: AAAIso = AAAIso
		var b: AAAIso = AAAIso

		// Создание AAAIso с другими ссылочными способностями возможно без recover,
		// т.к. iso приводим ко всем типам
		var c1: AAAIso val = AAAIso
		var c2: AAAIso val = AAAIso
		var c3: AAAIso tag = AAAIso
		var c4: AAAIso box = AAAIso
		var c5: AAAIso ref = AAAIso
		var c6: AAAIso trn = AAAIso

		// Создание AAAIso с ref
		var d: AAAIso ref = AAAIso

		d.inc()
		d.getX()


		var e: ActorIso = ActorIso
		e.y(c1)
		// e.y(c3) // это нельзя, т.к. tag к val не приводится
		// Это можно только с "потреблением" ссылки,
		// т.к. iso-ссылка должна существовать в единственном экземпляре
		a.inc()
		e.y(consume a)

		var b2: AAAIso val = consume b
		var b3: AAAIso val = b2
		e.y(b2)
		e.y(b3)

		e.printState(env)
		
		// Так нельзя
		// can't use a consumed local or field in an expression
		// a.getX()
		// b.getX()
		
		b3.getX()
		// b3.inc() // так нельзя, т.к. val не приводим к ref

		var m1: AAAIso = AAAIso
		// var m2: AAAIso = m1
		// Так нельзя
		// AAAIso iso! is not a subtype of AAAIso iso: iso! is not a subcap of iso
		// Здесь нужно использовать consume, т.к. копировать iso не получится

		// Вот это можно. iso! является алиасом ссылки m1 и приводим к AAAIso tag
		var m2: AAAIso iso! = m1
		var m3: AAAIso tag  = m2


		var k = 
		object iso is TraitIso
			var x: U64 = 1
			// Здесь iso-ссылка будет неявно приведена к ref, т.е. это можно вызывать из-под iso
			fun ref apply() =>
				x = x + 1
		end

		k()
		var k2: TraitIso val = consume k
		e.r(k2)


trait TraitIso
	fun ref apply()
	fun val read() =>
		None

// Для классов способность ссылок по умолчанию - ref
// Для акторов - tag
// Для примитивов - val
class iso AAAIso
	var x: U64 = 1

	fun ref inc(): U64 =>
		x = x + 1
	
	fun getX(): U64 =>
		x

	// iso здесь обязательно, иначе создаст ref
	new iso create() =>
		None


// По-умолчанию актор создаётся со способностью tag
actor ActorIso
	var x: U64 = 1

	fun ref w() =>
		x = x + 1

	be y(a: AAAIso val) =>
		x = x + a.x
	
	be r(a: TraitIso val) =>
		a.read()

	be printState(env: Env) =>
		env.out.print("ActorIso x == " + x.string())
