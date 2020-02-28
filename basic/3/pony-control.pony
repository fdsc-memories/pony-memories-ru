use "format"

// Глобальные переменные не поддерживаются

actor Main
	new create(env: Env) =>

		// Сопоставление с образцом на примере безопасной операции сложения
		// https://tutorial.ponylang.io/expressions/arithmetic.html#partial-and-checked-arithmetic
		let r = U32.max_value().addc(U32(1))
		match r		// см. ниже ещё match
			| (let result: U32, false) =>
				env.out.print(result.string())
			| (_, true) =>
				env.out.print("overflow")	// Будет выведена
		end

		// Проверка на ошибку при частичной операции сложения
		let x10e = 
		try
			U32.max_value() +? U32(1)
		else
			env.out.print("error with adding") 	// Будет выведена
		end

		env.out.print("U32.max_value() +? U32(1): " + x10e.string())  // None

		// Условные операторы
		// if поддерживает строго тип Bool
		if x10e is None then
			env.out.print("x10e is a None")	// Выведется это
		else
			env.out.print("x10e is not a None")

			let x10em = match x10e | let s: U32 => s else U32(0) end

			if x10em == 10 then
				env.out.print("x10em == 10")
			elseif x10em == 11 then
				None
			else
				None
			end
		end

		let friendly = false
		// if является выражением, то есть возвращает значение
		// var x =
		// так нельзя: right side must be a subtype of left side
		var x: (String | None) =
		if friendly then
			"Hello"
		else
			None	// Здесь может быть функция, возвращающая None, например env.out.print
		end

		// Это - то же самое, что и предыдущий вариант
		x =
		if friendly then
			"Hello"
		end


		// Частичный возврат тут не поддерживается:
		// из цикла будет возвращено только последнее значение, а не массив
		var x1: (String | None) = 
			for name in ["Bob"; "Fred"; "Sarah"].values() do
				name	// Будет запомнено последнее значение, которое принимала переменная name
			else
				None
			end

		match x1
			| let s: String => env.out.print("x1 is " + s)		// x1 is Sarah
			| None => env.out.print("x1 is None")
		end

		
		var counter: U32 = 0
		let cnt1: U32 = 
		while counter < 10 do
			counter = counter + 1
			break		// Возвращаемое значение идёт из блока else!!!
		else
			env.out.print("while1 else executed")	// Будет выведено на экран
			11
		end

		let cnt2: U32 = 
		while counter < 10 do
			counter = counter + 1
			if (counter < 5) then
				continue
			end
			break counter		// Возвращаемое значение отсюда, без блока else
		else
			env.out.print("while2 else executed")
			11
		end

		env.out.print("while " + cnt1.string())	// 11
		env.out.print("while " + cnt2.string())	// 2
		
		
		
		while counter < 10 do
			break None		// None - тоже возвращаемое значение, else не будет выполнено
		else
			env.out.print("while3 else executed")	// Это не будет выполнено
			None
		end


		// repeat также может содержать блок else
		counter = 0
		repeat
			counter = counter + 1
			env.out.print("repeat executed")
		until counter >= 2 end

		// Реализация итератора
		counter = 0
		for fibonacciNumber in FibonacciIterator do
			env.out.print("Fibonacci " + fibonacciNumber.string())
			counter = counter + 1
			if counter > 10 then
				break
			end
		end


class FibonacciIterator
	var f1: U64 = 1
	var f2: U64 = 1
	var cnt: U64 = 0

	fun has_next(): Bool =>
		true
		
	fun ref next(): U64 =>
		if cnt < 2 then
			cnt = cnt + 1
			return 1
		end

		let f = f1 + f2
		f1 = f2 = f
		f

