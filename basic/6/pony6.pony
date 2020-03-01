actor Main
	let env: Env
	new create(env': Env) =>
		env = env'
		main()

		// Эта надпись будет ранее, чем из функции main
		// поведение вызывается асинхронно даже внутри объекта
		env.out.print("Main.create end")

	be main() =>
		env.out.print("main1")

		let f = Class(env)		// Вызов конструктора create
		f()	// Class.apply
		
		let g1 = Class2(env)	// Class2.apply - вызов конструктора и функции apply

		// То же самое, что и строкой выше
		let g2 = Class2
		g2(env)					// Class2.apply
		
		// К этому вызову применяются все правила, которые применяются при вызовах
		f(3, 2) = 4				// Class.update with index=3, 2 and val=4
		var four: U32 = 4
		var five: U32 = 5


		// Объектный литерал (инлайн-объект)
		// Может реализовывать типажи, то есть object is ...
		// Можно объявлять как object iso is Applied, например
		// Если объект должен быть не классом, а актором,
		// то нужно объявить хотя бы один метод-подведение (be). Акторы возвращаются как tag
		// Объявление объекта является и его конструктором
		let inline = 
		object is Applied
			var four: U32 = four	// Приравниваем поле к переменной (делаем замыкание)
			fun ref apply(env: Env) =>
				four = 3
				env.out.print("inline object apply: " + four.string() + ", " + five.string())
				// inline object apply: 3, 5

			fun tag second(env: Env) =>
				env.out.print("inline object second")
		end

		four = 5
		five = 6

		after(inline)

		env.out.print("main2. four == " + four.string())	// main2. four == 5


	fun after(obj: Applied) =>
		obj(env)
/*
	be afterAsync(obj: Applied val) =>
		obj.second(env)
*/

trait Applied
	fun ref apply(env: Env)
	fun second(env: Env)


struct Class
	let env: Env
	new create(env': Env) =>
		env = env'

	fun apply() =>
		env.out.print("Class.apply")

	// value должен называться именно так. Рекомендуется, чтобы value был последним параметром
	// Других параметров может быть сколько угодно
	fun update(num: U64, num2: U64, value: U64) =>
		env.out.print("Class.update with index=" + num.string() + ", " + num2.string() + " and val=" + value.string())

struct Class2
	fun apply(env: Env) =>
		env.out.print("Class2.apply")
