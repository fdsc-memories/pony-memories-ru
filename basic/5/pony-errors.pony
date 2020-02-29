actor Main
	new create(env: Env) =>

		var x: U32 = 1

		// При ошибке блок try имеет значение из блока else,
		// в противном случае значение идёт из блока try
		try
			// Компилятор всегда проверяет, что все ошибки обработаны
			// Ошибка всегда одна, она не различается по типу
			if x != 2 then error end
		else
			x = 2
		end

		env.out.print("x == " + x.string())	// x == 2

		// Так тоже можно: ошибка будет просто проигнорирована
		// При ошибке такой блок try имеет значение None
		try
			if x != 3 then error end
			x = 3
		end

		env.out.print("x == " + x.string())	// x == 2

		// then выполняется всегда, кроме случаев зацикливания в try или else
		// или прекращения работы потока (снятие процесса, выключение машины)
		try
			if x == 2 then error end
		else
			None
		then	// then - аналог finally. Вызывается всегда
			env.out.print("called")	// Это будет вызвано
		end

		try
			if x != 2 then error end
		else							// then может декларироваться и без else
			None
		then
			env.out.print("called")	// Это тоже будет вызвано
		end
		
		// В конце блока для obj будет вызван метод dispose
		with obj = Disposable(env) do
			None
		end
		
		with obj = Disposable(env), obj2 = Disposable(env), obj3 = Disposable(env) do
			error
		else
			None
		end

		// оператор as может вызывать ошибку приведения типов
		// Другие языковые конструкции ошибок не вызывают

		


	// Частичная функция помечается после объявления знаком вопроса
	// Частичная функция может вернуть ошибку
	// Называется частичной, потому что значения функции
	// объявлены не для всего множества входных параметров
	fun func1() ? =>
		error
	
	fun func2(): I32 ? =>
		error


class ErrorInConstructor
	// Если в конструкторе произошла ошибка, объект отбрасывается весь целиком
	// Однако, в конструкторах акторов и be-методах (поведениях)
	// ошибки недопустимы, т.к. методы там выполняются асинхронно (в т.ч. и конструкторы)
	new create() ? =>
		error


class Disposable
	let env: Env

	new create(env': Env) =>
		env = env'
	
	fun dispose() =>
		env.out.print("disposed")
