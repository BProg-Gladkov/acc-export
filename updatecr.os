// Нужно отрефакторить, сделано на скорую руку

Перем КаталогИсходных;
Перем СписокПроблемныхМодулей;
Перем СписокВременныхФайлов;

Процедура ЗапуститьОбработку()

	СписокМодулей = НайтиФайлы(ОбъединитьПути(КаталогИсходных, ""), "*.bsl", Истина);
	КоличествоМодулей = СписокМодулей.Количество();
	НомерМодуля = 1;

	Для Каждого Модуль Из СписокМодулей Цикл

		Если Модуль.Расшение = "bsltmp" Тогда
			Продолжить;
		КонецЕсли;

		Сообщить(СтрШаблон("Обработка %1 из %2", НомерМодуля, КоличествоМодулей));

		ИмяФайла = Модуль.ПолноеИмя; 
		Если ЕстьОдиночныеCR(ИмяФайла) Тогда
			СписокПроблемныхМодулей.Добавить(ИмяФайла);
		КонецЕсли;
		
		НомерМодуля = НомерМодуля + 1;

	КонецЦикла;

	Сообщить("Найден модулей: " + СписокПроблемныхМодулей.Количество());
	Для Каждого Модуль Из СписокПроблемныхМодулей Цикл
		Сообщить("Исправление: " + Модуль);
		ЗаменитьОдиночныеCR(Модуль);
	КонецЦикла;


КонецПроцедуры

Функция ЗаменитьОдиночныеCR(ИмяФайла)

	ДвоичныеДанныеТело = Новый ДвоичныеДанные(ИмяФайла);
	Размер = ДвоичныеДанныеТело.Размер();
	ДвоичныеДанныеТело = Неопределено;

	ВременныйФайл = ПолучитьИмяВременногоФайла("bsl");

	ФайловыйПоток = ФайловыеПотоки.ОткрытьДляЧтения(ИмяФайла);	
	ЧтениеДанных = Новый ЧтениеДанных(ФайловыйПоток, КодировкаТекста.UTF8);
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Размер);	
	МойБуфер = Новый Массив;

	Для Каждого Байт Из Буфер Цикл
	
		Если Байт = 10 Тогда
			Продолжить;
		КонецЕсли;
		МойБуфер.Добавить(Байт);

	КонецЦикла;

	ФайловыйПоток.Закрыть();
			
	Запись = Новый ЗаписьДанных(ВременныйФайл, КодировкаТекста.UTF8);
	Пропустить = 1;
	Для Каждого Байт Из МойБуфер Цикл
		Если Пропустить > 3 Тогда
			Запись.ЗаписатьБайт(Байт);
			Если Байт = 13 Тогда
				Запись.ЗаписатьБайт(10);	
			КонецЕсли;
		КонецЕсли;
		Пропустить = Пропустить + 1;
	КонецЦикла;
	Запись.Закрыть();

	ВременныйФайлИсходника = ИмяФайла + "tmp";
	КопироватьФайл(ИмяФайла, ВременныйФайлИсходника);
	
	СписокВременныхФайлов.Добавить(ВременныйФайл);
	СписокВременныхФайлов.Добавить(ВременныйФайлИсходника);

	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		Сообщить("Не удалось обработать файл: " + ИмяФайла);
	КонецПопытки;
	ПереместитьФайл(ВременныйФайл, ИмяФайла);

	ОчиститьВременныеФайлы();

КонецФункции

Процедура ОчиститьВременныеФайлы()

	Для Каждого ВременныйФайл Из СписокВременныхФайлов Цикл
		Попытка
			УдалитьФайлы(ВременныйФайл);
		Исключение
			Сообщить("Не удалось удаить файл: " + ВременныйФайл);
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьТекстМодуля(ИмяФайла)

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ИмяФайла, КодировкаТекста.UTF8);
	Текст = ТекстовыйДокумент.ПолучитьТекст();
	ТекстовыйДокумент = Неопределено;
	Возврат Текст;	
	
КонецФункции

Функция ЕстьОдиночныеCR(ИмяФайла)
	
	ДвоичныеДанныеТело = Новый ДвоичныеДанные(ИмяФайла);
	Размер = ДвоичныеДанныеТело.Размер();
	ДвоичныеДанныеТело = Неопределено;

	ФайловыйПоток = ФайловыеПотоки.ОткрытьДляЧтения(ИмяФайла);	
	ЧтениеДанных = Новый ЧтениеДанных(ФайловыйПоток, КодировкаТекста.UTF8);
	
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Размер);
	Позиция = 0;
	Для Каждого ТекБайт Из Буфер Цикл

		Если ТекБайт = 13 Тогда
	
			Попытка
				СледующийБайт = Буфер[Позиция + 1];
			Исключение
				Возврат Ложь;
			КонецПопытки;

			Если СледующийБайт <> 10 Тогда
				Возврат Истина;
			КонецЕсли;

		КонецЕсли;

		Позиция = Позиция + 1;

	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

СписокПроблемныхМодулей = Новый Массив;
СписокВременныхФайлов = Новый Массив;
КаталогИсходных = ОбъединитьПути(ТекущийСценарий().Каталог, "src");

ЗапуститьОбработку();