actor Main
	new create(env: Env) =>
		env.out.print("while3 else executed")
		let a1 = AAA	// create
		let a2 = AAA.create2()
		let a3: AAA = a3.create()
		a3.func3(1, 1)
		a3.func3(where a = 1, b = 1)	// То же, что и предыдущая строка
		a3.func3(1 where b = 1)			// То же, обращаем внимание: нет запятой перед where

		a3.func4(where b = 1)	// Здесь a = None

		// Последовательный вызов метода с отбрасыванием результата
		// Обращаем внимание на то, что первый вызов тоже .>
		a1.>func1(1).>func2(1, 2).>func3().>func4(where b = 1)

		// Это то же самое, что и
		a1.func1(1)
		a1.func2(1, 2)
		a1.func3()
		a1.func4(where b = 1)


		// Лямбды декларируются в фигурных скобках
		// https://tutorial.ponylang.io/expressions/object-literals.html
		a1.func5( {(u: U32) => u} )

		// вторые скобки - для захватываемых лексическим замыканием параметров
		// объявление типа лямбды :U32 можно опустить
		env.out.print(
			a1.func5({(u: U32)(env): U32 => env.out.print("lambda"); u }).string()
		)

		// e - псевдоним для env
		env.out.print(
			a1.func5({(u: U32)(e = env) => e.out.print("lambda2"); u }).string()
		)
		
		
		// Частичное применение (Partial Application)
		let xxx: XXX = XXX
		let f = xxx~getX(where env = env)	// Применяем операнд не по-очереди
		let g = f~apply(3)					// Частично применяем частичное применение
		env.out.print("g() = " + g().string())	// Делаем вызов уже без параметров



struct XXX
	let x: U32 = 0

	fun getX(add: U32, env: Env): U32 =>
		env.out.print("XXX.getX")
		add + x

class AAA
	// Параметр является неизменяемым
	fun func1(a: U32): U32 =>
		a

	// Перегрузка функций невозможна
	// return бывает, но только не в конце метода
	fun func2(a: U32, b: U32): U32 =>
		func1(a)

	// Главный конструктор
	new create() =>
		None

	new create2() =>
		None

	// Допустимы параметры по умолчанию
	fun func3(a: (U32 | None) = None, b: U32 = 0): U32 =>
		match a
			| let r: U32 => r
			| None => 0
		end

	// Допустимы параметры по умолчанию и не по порядку
	fun func4(a: (U32 | None) = None, b: U32): U32 =>
		match a
			| let r: U32 => r
			| None => 0
		end

	// Лямбды: f - это функция, которая принимает один аргумент U32 и возвращает U64
	fun func5(f: {(U32): U32}): U32 =>
		f(987654321)
		
	// Два символа подчёркивания в начале имени метода не бывает
	// Один в начале - приватный метод, аналогично полям
	fun _privateMethod() =>
		None

