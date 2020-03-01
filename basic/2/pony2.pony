use "format"

// Глобальные переменные не поддерживаются

actor Main
	new create(env: Env) =>

		// Стандартный тип None, используется вместо null
		// var x: (String | None)

		// type DoorState is (OpenedDoor | ClosedDoor)

		// Пример работы с объединением типов
		let doorState : DoorState = ClosedDoor

		let isDoorOpen : Bool =
		match doorState
		  | OpenedDoor => true
		  | ClosedDoor => false
		end

		// Можно инициализировать переменную потом, после декларации, в отличие от let
		// Компилятор сам проверит, что переменная точно инициализирована
		var i: U8
		i = 2

		// На консоли русский будет кракозяброй
		env.out.print("Дверь открыта (Door opened): " + isDoorOpen.string())

		// Строковые литералы берутся из файла как есть, в той же кодировке, что и файл
		let pony = "🐎"
		let pony_hex_escaped = "p\xF6n\xFF"
		let pony_unicode_escape = "\U01F40E"
		let pony2 = "\uF09F\u908E"

		env.out.print(pony + " | " + pony_hex_escaped + " | " + pony_unicode_escape + " | " + pony2)
		for b in pony.values() do
		  env.out.print(Format.int[U8](b, FormatHex))
		end

		// Строки могут определяться в кавычках " или тройных кавычках """
		// Все строки могут быть многострочными
		env.out.print(	// к сожалению, скобку придётся делать на той же строке
		"0
		1
		2
		3
		4
		"
		// Аккуратненько смотрим: 0 будет в начале строки, остальные цифры заимствуют отступ кода
		)

		// Здесь отступ заимствоваться не будет. 0 - это нулевая строка многострочной строки
		env.out.print(
		"""
		0
		1
		2
		3
		4
		"""
		)

		// Объявляем строковый массив
		// Оператор ";" разделяет выражения на одной строке
		let my_literal_array =
		[
			"first"; "second"
			"third one on a new line"
		]

		for b in my_literal_array.values() do
		  env.out.print(b)
		end
		/* Вывод:
			first
			second
			third one on a new line
		*/

		// Гетерогенный массив Array[(U64|String)] ref
		// Этот массив содержит и строки, и числа
		let my_heterogenous_array = 
		[
			U64(42)
			"42"
			U64.min_value()
		]

		// Это гомогенный массив из объектов-контейнеров (см. ниже использование)
		let my_Stringable_array: Array[Stringable] ref = 
		[
			U64(42)
			"42"
			U64.min_value()
		]
		
		// Это то же
		let my_Stringable_array2 = 
		[ as Stringable:
			U64(42)
			"42"
			U64.min_value()
		]

		for b in my_heterogenous_array.values() do
		  env.out.print(b.string())
		end
		/* Вывод:
			42
			42
			0
		*/

		for b in my_Stringable_array.values() do
		  env.out.print(b.string())
		end

		env.out.print("-------------------------------")

		// Здесь мы берём через функции apply значения ColourList.apply()
		for colour in ColourList().values() do
			// colour - это один из типов цветов
			// colour() == colour.apply()
			env.out.print(colour().string())
		end

		// Кортежи (tuples)
		var x: (String, U64)
		x = ("hi",  3)
		x = ("bye", 7)
		(var y, var z) = x
		var x1 = x._1
		var x2 = x._2

		// Number - см. ниже определение, это все численные типы
		// Чтобы приравнять к aa какое-то число напрямую, придётся конкретно указать его тип
		// Иначе будет выдана ошибка компиляции Multiple possible types for literal
		let aa: Number = U64(0)

		var a = Aliases
		a.getAliases(env)

		let ca = ComplexValue(1, 5, env)
		let cb = ComplexValue(2, 7, env)

		// Оператор "+" является алиасом функции add(...), см. ниже
		env.out.print((ca + cb).string())
		
		env.out.print("----------------------------------")

		// Здесь будет переполнение без ошибки
		var x10  = U32.max_value() + 1
		if ((U32.max_value() + 1) == x10) then
			// U32.max_value() + 1 == x10 is true
			// Никакого контроля переполнения он не делает, хотя в справке написано, что делает
			env.out.print("U32.max_value() + 1 == x10 is true")	// Это будет выведено
		end

		env.out.print("U32.max_value() + 1: " + x10.string())  // 0
		
		x10 = U32.max_value() +~ U32(1) // значение остаётся тем же, что и было ранее: похоже на ошибку в компиляторе, причём она не повторяется отдельно
		env.out.print("U32.max_value() +~ 1: " + x10.string())  // 4294967295

		var null: U32 = 0
		x10 = x10 / null
		env.out.print("x10 / 0: " + x10.string())  // тоже 0
		env.out.print("10 % 6: " + U32(10 %  6).string())  // 4
		var x128: I8 = -128
		x128 = -x128
		env.out.print("-(-128): " + x128.string())  // -128

		// Partial and Checked Arithmetic
		let x10e = 
		try
			U32.max_value() +? U32(1)
		else
			env.out.print("error with adding") 
		end

		env.out.print("U32.max_value() +? U32(1): " + x10e.string())  // None

		// https://tutorial.ponylang.io/expressions/arithmetic.html#unsafe-conversion
		// Преобразования чисел из формата в формат

		let x12 = I32(12).f32()
		env.out.print("I32(12).f32(): " + x12.string())  // 12
		let x13 = U32(1) / U32(3)
		env.out.print("1 / 3: " + x13.string())  // 0
		
		x10 = U32.max_value() - U32(1)
		x10 = x10 + 3	// += - здесь такого нет
		env.out.print("U32.max_value() - U32(1) + 3: " + x10.string())  // 1 - проверить позже на обоих операциях + и +~, т.к. и там, и там даёт переполнение
		
		// "is" проверяет на равенство идентичностей (то есть равенство ссылок)
		// None - единственный объект (синглтон), так что можно проверять на равенство
		let xNone = None
		if xNone is None then
			None
		end

		// fun eq(that: box->Foo): Bool
		// Будет вызван ComplexValue.eq при сравнении ==, и ComplexValue.ne при сравнении !=
		// При сравнении примитивы сравниваются оператором "is", т.к. они - синглтоны
		if ca != cb then
			None
		else
			None
		end


// Примитивный тип - не имеет никаких полей
primitive OpenedDoor
	// Инициализатор вызывается перед стартом любых акторов
	// Все инициализаторы (разных примитивов) вызываются последовательно
	fun _init() =>
		// Здесь ещё нет env, так что так не получится. А env.out вообще актор
		// env.out.print("OpenedDoor init")
		let a: U8 = 2

	fun _final() =>
		let b: U8 = 1

	// Примитив может содержать функции
	// Например, они могут содержать значения констант
	fun getValue(): U8 =>
		1

// Примитивный тип может быть вот просто таким - без ничего
primitive ClosedDoor

// Это тип-перечисление (он же объединение типов - один из типов),
// DoorState является алиасом для типа-перечисления (OpenedDoor | ClosedDoor)
type DoorState is (OpenedDoor | ClosedDoor)


trait Named
	fun name(): String => "Bob"

// Функция hair уже реализована
// Функция height должна быть реализована в классе, реализующем признак
trait Bald
	fun hair(): Bool => false
	fun height(): F32

// Пересечение типажей (оба типажа реализуются классом Bob)
// Класс заимствует определения функций
class Bob is (Named & Bald)
	// Здесь класс вынужден реализовать функцию height из признака Bald
	fun height(): F32 =>
		0.0


primitive Red    fun apply(): U32 => 0xFF0000FF
primitive Green  fun apply(): U32 => 0x00FF00FF
primitive Blue   fun apply(): U32 => 0x0000FFFF

type Colour is (Red | Blue | Green)

primitive ColourList
  fun apply(): Array[Colour] =>
    [Red; Green; Blue]


// Интерфейсы используют утиную типизацию (structural typing)
// То есть интерфейс автоматически наследуется, если есть все методы из этого интерфейса
interface HasName
	fun name(): String

/*
Элементарные типы

Bool. This is a 1-bit value that is either true or false.
ISize, ILong, I8, I16, I32, I64, I128. Signed integers of various widths.
USize, ULong, U8, U16, U32, U64, U128. Unsigned integers of various widths.
F32, F64. Floating point numbers of various widths.

Типы Size и Long являются целыми числами, размер которых зависит от платформы

let my_explicit_unsigned: U32 = 42_000
let my_constructor_unsigned = U8(1)
let my_constructor_float = F64(1.234)

let my_decimal_int: I32 = 1024
let my_hexadecimal_int: I32 = 0x400
let my_binary_int: I32 = 0b10000000000

Восьмиричных чисел здесь нет

let my_double_precision_float: F64 = 0.009999999776482582092285156250
let my_scientific_float: F32 = 42.12e-4

let big_a: U8 = 'A'                 // 65
let hex_escaped_big_a: U8 = '\x41'  // 65
let newline: U32 = '\n'             // 10

Экранирующие символы
\x4F hex escape sequence with 2 hex digits (up to 0xFF)
\a, \b, \e, \f, \n, \r, \t, \v, \\, \0, \'

let multiByte: U64 = 'ABCD' // 0x41424344


Строки

\u00FE unicode escape sequence with 4 hex digits encoding one code point
\U10FFFE unicode escape sequence with 6 hex digits encoding one code point
\x4F hex escape sequence for unicode letters with 2 hex digits (up to 0xFF)
\a, \b, \e, \f, \n, \r, \t, \v, \\, \0, \"


type Number is (Signed | Unsigned | Float)

type Signed is (I8 | I16 | I32 | I64 | I128)

type Unsigned is (U8 | U16 | U32 | U64 | U128)

type Float is (F32 | F64)

*/


// Структуры - это классы для FFI
struct Inner
	var x: I32 = 0

// В объявлениях полей декларации обязательны
struct Outer
	// Структура Inner будет встроена по значению, прямо в тело, без ссылки на новый объект
	// Встраиваться могут только классы и структуры
	embed inner_embed: Inner = Inner

	// Эта структура будет выделена отдельно, а в поле будет хранится её адрес
	// Значение переменной должно быть обязательно присвоено
	// либо в конструкторе, либо в инициализаторе вне зависимости от того, var это или let
	// Причём именно в конструкторе, а не в методе, который вызывается из конструктора
	var inner_var: Inner = Inner
	let  x: U64 = 1
	// Приватное поле. protected полей нет, т.к. нет наследования
	let _y: U64 = 1


class A

type AAlias1 is A

class Aliases

	fun getAliases(env: Env) =>
		env.out.print("Aliases")
		var a = A
		var b: AAlias1 iso = AAlias1

		//  c: Array[A iso!]
		// Насчёт "!" https://tutorial.ponylang.io/expressions/literals.html см. в конце
		// https://tutorial.ponylang.io/reference-capabilities/aliasing.html тоже в конце
		// Похоже, что типы должны быть приведены к A iso с точки зрения reference capabilites
		// Потому что если убрать "!", то переменная "a" будет неверного типа
		// (она будет типа A ref)
		// Как видно, алиасы, сделанные type, совершенно спокойно заходят в такой массив
		var c: Array[A iso!] = 
		[
			a
			b
		]

		// c.push(c)	// Это можно раскомментировать, чтобы узнать тип
		
struct ComplexValue
	let real: F64
	let img : F64
	let env : Env

	fun eq(e: ComplexValue): Bool =>

		env.out.print("ComplexValue.eq")

		if real != e.real then
			return false
		end

		img == e.img

	fun ne(e: ComplexValue): Bool =>
		not eq(e)

	new create(real': F64, img': F64, env': Env) =>
		real = real'
		img  = img'
		env  = env'

	// Теперь можно использовать оператор "+", он определится автоматически
	fun add(x: ComplexValue): ComplexValue =>
		ComplexValue(real + x.real, img + x.img, env)

	fun string(): String =>
		let s: String = "(" + real.string() + ", " + img.string() + ")"
		s

/*
Переопределение and и or даёт полное вычисление условий if (x and y) и if (x or y)
То есть сокращённое вычисление условий применяется только для булевских типов
*/

/*
Приоритеты операторов см. https://tutorial.ponylang.io/expressions/ops.html
Раздел Precedence

Операторы вызова метода и обращения к полю являются наиболее приоритетными

Унарные операторы применяются перед бинарными not a == b  <==>  (not a) == b

Инфиксные операторы не имеют приоритетов
1 + 2 * 3  // Compilation failed.
1 + (2 * 3)  // 7

То есть нужно явно использовать скобки абсолютно всегда, если в наличии хотя бы два разных инфиксных оператора, иначе будет ошибка

1 + 2 * -3  // Compilation failed.
1 + (2 * -3)  // -5

Работает:
1 + -(2 * -3)  // 7
*/

// https://tutorial.ponylang.io/expressions/ops.html
/*
The full list of unary operators that are aliases for functions is:

Operator	Method	Description
-	neg()	Arithmetic negation
not	op_not()	Not, both bitwise and logical
-~	neg_unsafe()	Unsafe arithmetic negation


The full list of infix operators that are aliases for functions is:

Operator	Method	Description	Note
+	add()	Addition	
-	sub()	Subtraction	
*	mul()	Multiplication	
/	div()	Division	
%	rem()	Remainder	
%%	mod()	Modulo	Starting with version 0.26.1
<<	shl()	Left bit shift	
>>	shr()	Right bit shift	
and	op_and()	And, both bitwise and logical	
or	op_or()	Or, both bitwise and logical	
xor	op_xor()	Xor, both bitwise and logical	
==	eq()	Equality	
!=	ne()	Non-equality	
<	lt()	Less than	
<=	le()	Less than or equal	
>=	ge()	Greater than or equal	
>	gt()	Greater than	
>~	gt_unsafe()	Unsafe greater than	
+~	add_unsafe()	Unsafe Addition	
-~	sub_unsafe()	Unsafe Subtraction	
*~	mul_unsafe()	Unsafe Multiplication	
/~	div_unsafe()	Unsafe Division	
%~	rem_unsafe()	Unsafe Remainder	
%%~	mod_unsafe()	Unsafe Modulo	Starting with version 0.26.1
<<~	shl_unsafe()	Unsafe left bit shift	
>>~	shr_unsafe()	Unsafe right bit shift	
==~	eq_unsafe()	Unsafe equality	
!=~	ne_unsafe()	Unsafe non-equality	
<~	lt_unsafe()	Unsafe less than	
<=~	le_unsafe()	Unsafe less than or equal	
>=~	ge_unsafe()	Unsafe greater than or equal	
+?	add_partial()?	Partial Addition	
-?	sub_partial()?	Partial Subtraction	
*?	mul_partial()?	Partial Multiplication	
/?	div_partial()?	Partial Division	
%?	rem_partial()?	Partial Remainder	
%%?	mod_partial()?	Partial Modulo	Starting with version 0.26.1
*/