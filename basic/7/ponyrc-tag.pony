/*
Tag - самая простая способность
Она удобна для работы с акторами

Можно сравнивать два объекта с помощью оператора is
Можно вызывать методы, помеченные способностью tag
Можно отсылать сообщения (вызывать методы-поведения "be")
*/

class TagIllustrator
	let env: Env
	new create(env': Env) =>
		env = env'

	fun apply() =>
		// Учитывая декларацию класса, a: AAA то же самое, что и a: AAA tag
		// Если бы в объявлении класса AAA не было бы указания tag, то a: AAA - это a: AAA ref
		var a: AAA = AAA
		var b: AAA = AAA
		
		// Можно вызывать методы со способностью tag
		a.aaa(1)
		// Сравнивать tag можно
		b is a

		// Создание AAA с val
		var c: AAA val = AAA.create_val()
		c.bbb()
		// Создание AAA с ref
		var d: AAA ref = AAA


		// e: Actor tag
		var e: Actor = Actor
		// e.w() - методы вызывать нельзя, кроме методов со способностью tag
		e.y()	// - сообщения посылать можно
		e.printState(env)


		
// Для классов способность ссылок по умолчанию - ref
// Для акторов - tag
// Для примитивов - val
class tag AAA
	let x: U64 = 1
	let b: BBB = BBB
	fun tag aaa(y: U64): U64 =>
		// Здесь нельзя читать/писать поля, т.к. это tag
		// can't read a field through AAA tag
		// x == y
		// Поля нельзя читать, даже если они сами tag
		// y + b()
		y

	fun bbb(): U64 =>
		x

	// Создаёт ref, не tag
	new create() =>
		None

	// Создаёт объект со способностью val
	new val create_val() =>
		None

class tag BBB
	fun tag apply(): U64 =>
		1

// По-умолчанию актор создаётся со способностью tag
actor Actor
	var x: U64 = 1

	fun ref w() =>
		x = x + 1

	be y() =>
		w()
		x = x + 1
		
	be printState(env: Env) =>
		env.out.print("x == " + x.string())
