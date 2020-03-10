/*
Перечень способностей ссылок https://tutorial.ponylang.io/reference-capabilities/reference-capabilities.html#the-list-of-reference-capabilities
https://tutorial.ponylang.io/reference-capabilities/guarantees.html


https://tutorial.ponylang.io/reference-capabilities/capability-subtyping.html
https://bluishcoder.co.nz/2017/07/31/reference_capabilities_consume_recover_in_pony.html
http://jtfmumm.com/blog/2016/03/06/safely-sharing-data-pony-reference-capabilities/

			   --> ref --
              /          \
iso --> trn --            --> box --> tag
              \          /
               --> val --

iso! --> tag
trn! --> box

ref! --> ref
val! --> val
box! --> box
tag! --> tag


------------------------------------------------------
Упрощённо говоря, tag является самой "внешней" (глобальной) ссылкой: его можно передавать куда угодно
iso также является "внешней" ссылкой, но уникальной
val является "внешней" ссылкой, допускает неограниченное копирование, но только для чтения
ref является строго внутренней для актора ссылкой, которая существовует только внутри объектов актора и никак не должна быть передана наружу
trn/box являются внутренними (локальными) ссылакми

Существование любых других ссылок уничтожает уникальную iso-ссылку

Viewpoints (точка зрения на объект в зависимости от ссылочных способностей) всегда не видят то, что нарушает целостность (нарушает ссылочные способности). Например, val-объект не будет видеть ref-функций

Нужно проиллюстрировать
recover - что это выражение, которое внутри себя содержит непосылаемые типы, которые так и остаются внутри

Стрелочные типы
https://tutorial.ponylang.io/reference-capabilities/arrow-types.html
*/

actor Main
	let env: Env
	new create(env': Env) =>
		env = env'

		// Тип tag и создание разных ссылочных типов из конструкторов
		// ponyrc-tag.pony
		TagIllustrator(env)()
		
		// Тип ref и создание разных ссылочных типов из ref с помощью recover
		// (сложные recover см. ниже)
		// ponyrc-ref.pony
		RefIllustrator(env)()

		// Тип iso, преобразование в val и потребление (consume) для передачи в актор
		// Алиасы ссылок (знак "!" после типа ссылки)
		// ponyrc-iso.pony
		IsoIllustrator(env)()
		
		// Тип trn и box
		TrnIllustrator(env)()
		
		
