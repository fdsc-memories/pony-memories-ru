/*
Ref
Она удобна для работы с объектом внутри одного актора

Можно делать с ref-объектом всё, что угодно, только не передавать объект через сообщения в другие акторы
По сути, это обычная ссылка на объект, привязанная к актору
*/

class RefIllustrator
	let env: Env
	new create(env': Env) =>
		env = env'

	fun apply() =>
		// Учитывая декларацию класса, a: AAARef то же самое, что и a: AAARef tag
		// a: AAARef - это тоже, что и a: AAARef ref
		var a: AAARef = AAARef
		var b: AAARef = AAARef

		// см. также пример recover ponyrc-ref.pony pony6.pony
		// Создание AAARef с другими ссылочными способностями с помощью выражения recover .. end
		var c1: AAARef val = recover val AAARef end
		var c2: AAARef val = recover     AAARef end
		var c3: AAARef tag =             AAARef
		var c4: AAARef box =             AAARef
		var c5: AAARef iso = recover     AAARef end
		var c6: AAARef trn = recover     AAARef end

		// Создание AAARef с ref
		var d: AAARef ref = AAARef

		d.inc()
		d.getX()

		// e: ActorRef tag
		var e: ActorRef = ActorRef
		// e.w() - методы вызывать нельзя, кроме методов со способностью tag
		e.y()	// - сообщения посылать можно
		e.printState(env)


		
// Для классов способность ссылок по умолчанию - ref
// Для акторов - tag
// Для примитивов - val
class AAARef
	var x: U64 = 1

	fun ref inc(): U64 =>
		x = x + 1
	
	fun getX(): U64 =>
		x

	// Создаёт ref
	new create() =>
		None


// По-умолчанию актор создаётся со способностью tag
actor ActorRef
	var x: U64 = 1

	fun ref w() =>
		x = x + 1

	be y() =>
		w()
		x = x + 1
		
	be printState(env: Env) =>
		env.out.print("ActorRef x == " + x.string())
