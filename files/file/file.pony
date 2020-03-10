use "files"

actor Main
	let env: Env
	let out: OutStream

	new create(env': Env) =>
		env = env'
		out = env.out
		main()

	be main() =>
		out.print("Create file tmp.txt")
		// env.root - https://stdlib.ponylang.io/builtin-AmbientAuth/
		// это специальная способность, как-то непонятно управляющая доступом
		try
			let path: FilePath = FilePath(env.root as AmbientAuth, "tmp.txt")?
			createFile(path)
		else
			out.print("Create FilePath to tmp.txt failed")
		end


	be createFile(path: FilePath) =>
		let file' = CreateFile(path)
		match file'
			| let file: File =>
				file.print("Новая строка UTF-8")
			else
				out.print("Create file tmp.txt failed")
		end
