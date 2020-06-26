﻿#Область ОбработчикиСобытийФормы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	УстановитьЗаголовокФормы();
	
	ОбработатьПараметрыЗапуска();
	ПостОбработкаВывестиПараметрыВСообщения();
	ПараметрыЗаполненыКорректно = ПроверитьЗаполнениеПараметровОбработки();
	
	Если ПараметрыЗаполненыКорректно
		И Не РежимОтладки Тогда
		
		ВыгрузитьОшибки();
		
	КонецЕсли;
	
	Если Не РежимОтладки Тогда
		Отказ = Истина;
		ЗавершитьРаботуСистемы(Ложь, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ПустаяСтрока(ФорматЭкспорта) Тогда
		ФорматЭкспорта = ФорматЭкспортаReportJSON;
		УстановитьЗначениеФорматаЭкспортаНаФорме(ФорматЭкспорта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

Процедура КаталогПроектаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	// перевести в немодальное
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выбор каталога проекта";
	Если Диалог.Выбрать() Тогда
		КаталогПроекта = Диалог.Каталог + ПолучитьРазделительПути();
		ПостОбработкаПараметров();
	КонецЕсли;
	
КонецПроцедуры

Процедура ФорматЭкспортаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ФайлКлассификацииОшибокНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	// перевести в немодальное
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Укажите файл классификации ошибок";
	Диалог.Фильтр = "Текстовый документ(*.csv)|*.csv";
	Если Диалог.Выбрать() Тогда
		ФайлКлассификацииОшибок = Диалог.ПолноеИмяФайла; 
		ПостОбработкаПараметров();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	ВыгрузитьОшибки();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыПрочитатьФайлПараметров(Кнопка)
	
	СтандартнаяОбработка = Ложь;
	// перевести в немодальное
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Укажите файл параметров acc.properties";
	Диалог.Фильтр = "acc.properties|acc.properties";
	Если Диалог.Выбрать() Тогда
		
		ПрочитатьФайлПараметров(Диалог.ПолноеИмяФайла);
		ПостОбработкаПараметров();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДействияФормыПолучитьТекстДляФайлаПараметров(Кнопка)
	
	массивСтрок = Новый Массив;
	
	массивСтрок.Добавить("acc.projectKey=" + Конфигурация.Наименование);
	массивСтрок.Добавить("acc.catalog=" + КаталогПроекта);
	массивСтрок.Добавить("acc.result=" + СтрЗаменить(ИмяФайлаРезультата, КаталогПроекта, "./"));
	массивСтрок.Добавить("acc.sources=" + СтрЗаменить(КаталогИсходныхКодов, КаталогПроекта, "./"));
	массивСтрок.Добавить("acc.check=" + Формат(ВыполнятьПроверку, "БЛ=false; БИ=true"));
	массивСтрок.Добавить("acc.format=" + ФорматЭкспорта);
	массивСтрок.Добавить("acc.titleError=" + ФорматПредставленияОшибки);
	массивСтрок.Добавить("acc.relativePathToFiles=" + Формат(ВыводитьОтносительныеПути, "БЛ=false; БИ=true"));
	массивСтрок.Добавить("acc.objectErrors=" + Формат(ВыводитьОшибкиОбъектов, "БЛ=false; БИ=true"));
	массивСтрок.Добавить("acc.recreateProject=" + Формат(ПересоздатьКонфигурацию, "БЛ=false; БИ=true"));
	массивСтрок.Добавить("acc.exportRules=" + Формат(ВыгружатьПравила, "БЛ=false; БИ=true"));
	массивСтрок.Добавить("acc.fileClassificationError=" + СтрЗаменить(СтрЗаменить(ФайлКлассификацииОшибок,"\","/"), КаталогПроекта, "./"));
	
	ВвестиСтроку(СтрСоединить(массивСтрок, Символы.ПС), , , Истина);
	
КонецПроцедуры

Процедура ДействияФормыКлассификацияОшибок(Кнопка)
	
	ФормаКлассификации = ПолучитьФорму("КлассификацияОшибок",, ЭтаФорма);
	ФормаКлассификации.Открыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьОшибки()
	
	ПересоздатьКонфигурацию();
	ЗапускПроверки();
	ИнициализироватьПервичныеДанные();
	Если фФайлСуществует(ФайлКлассификацииОшибок) Тогда
		АдресФайлаКлассификацииВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлКлассификацииОшибок));
	КонецЕсли;
	ЭкспортироватьОшибкиАПК();
	
КонецПроцедуры

Процедура ПересоздатьКонфигурацию()
	
	Если Не (ЗначениеЗаполнено(Конфигурация)
		И ПересоздатьКонфигурацию) Тогда
		Возврат;
	КонецЕсли;
	
	новКонфигурация = Конфигурация.Скопировать();
	новКонфигурация.ЭтоКопия = Ложь;
	новКонфигурация.ОбъектКопия = Неопределено;
	новКонфигурация.Записать();
	
	старКонфигурацияОбъект = Конфигурация.ПолучитьОбъект();
	старКонфигурацияОбъект.Наименование = "Удалить_" + старКонфигурацияОбъект.Наименование;
	старКонфигурацияОбъект.Записать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	&НоваяКонфигурация КАК Конфигурация,
	|	ТребованияККонфигурации.ВариантПроверки КАК ВариантПроверки,
	|	ТребованияККонфигурации.Требование КАК Требование,
	|	ТребованияККонфигурации.Ошибка КАК Ошибка
	|ИЗ
	|	РегистрСведений.ТребованияККонфигурации КАК ТребованияККонфигурации
	|ГДЕ
	|	ТребованияККонфигурации.Конфигурация = &Конфигурация";  
	Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	Запрос.УстановитьПараметр("НоваяКонфигурация", новКонфигурация.Ссылка);
	
	нз = РегистрыСведений.ТребованияККонфигурации.СоздатьНаборЗаписей();
	нз.Отбор.Конфигурация.Установить(новКонфигурация.Ссылка);
	нз.Загрузить(Запрос.Выполнить().Выгрузить());
	нз.Записать();
	
	Конфигурация = новКонфигурация.Ссылка;
	
КонецПроцедуры

Процедура ЗапускПроверки()
	
	Если Не ВыполнятьПроверку
		Или Не ЗначениеЗаполнено(Конфигурация) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Лог_Информация("Начало проверки конфигурации " + ТекущаяДата());
	
	ФормаЗапускаПроверки = ПолучитьФорму("Обработка.ЗапускПроверки.Форма");
	ФормаЗапускаПроверки.ОбработкаОбъект.ПоказыватьПредупреждения = Ложь;
	ФормаЗапускаПроверки.Конфигурация = Конфигурация;
	ФормаЗапускаПроверки.РегистрироватьВсеОшибкиКакОсобенности = Ложь;
	ФормаЗапускаПроверки.Открыть();
	ТекстОшибки = ФормаЗапускаПроверки.ВыполнитьПроверку();
	ФормаЗапускаПроверки.Закрыть();
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		
		Лог_Информация("При выполнении проверки произошла ошибка: ");
		Лог_Информация(ТекстОшибки);
		
	КонецЕсли;
	
	Лог_Информация("Окончание проверки конфигурации " + ТекущаяДата());
	
КонецПроцедуры

Процедура УстановитьЗначениеФорматаЭкспортаНаФорме(Знач ВходящееЗначение)
	
	Элемент = ЭтаФорма.ЭлементыФормы.ФорматЭкспорта;
	СписокВыборка = Элемент.СписокВыбора;
	
	ВходящееЗначение = нРег(ВходящееЗначение);
	Значение = СписокВыборка.НайтиПоЗначению(ВходящееЗначение);
	Элемент.Значение = Значение;
	
КонецПроцедуры

Процедура УстановитьЗаголовокФормы()
	
	Лог_Информация("Версия обработки " + ВерсияОбработки);
	ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " v." + ВерсияОбработки;
	
КонецПроцедуры

#Область ОбработкаПараметров

Процедура ОбработатьПараметрыЗапуска()
	
	// Порядок чтения параметров
	// Файл параметров берется из аргумента, если не указан, то ищется рядом с обработкой
	// Параметры читаются из аргументов, если не указаны, то из файла параметров
	
	ПутьКФайлуПараметров = "";
	
	ПутьКФайлуОбработки = АбсолютныйПуть(ИспользуемоеИмяФайла);
	
	РежимОтладки = Не ЗначениеЗаполнено(ПараметрЗапуска);
	
	Аргументы = СтрРазделить(ПараметрЗапуска, ";", Ложь);
	ФайлОбработки = Новый Файл(ИспользуемоеИмяФайла);
	ПутьКФайлуОбработки = ФайлОбработки.Путь;
	
	Для каждого цАргумент Из Аргументы Цикл
		
		ЗаполнитьПараметр(цАргумент, "acc.propertiesPaths", ПутьКФайлуПараметров);
		Если вРег(цАргумент) = "/DEBUG" Тогда // за счет параметра открываем для отладки в клиенте
			РежимОтладки = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ПутьКФайлуПараметров) Тогда
		
		ПутьКФайлуПараметров = ПутьКФайлуОбработки + "acc.properties";
		
	КонецЕсли;
	
	ПрочитатьФайлПараметров(ПутьКФайлуПараметров);
	
	Для каждого цАргумент Из Аргументы Цикл
		
		ПрочитатьПараметрыВСтроке(цАргумент);
		
	КонецЦикла;
	
	ОбеспечитьАбсолютныйПутьККаталогу(ПутьКФайлуОбработки);
	ПостОбработкаПараметров();
	
КонецПроцедуры

Функция ПроверитьЗаполнениеПараметровОбработки()
	
	Результат = Истина;
	
	Если Конфигурация.Пустая() Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Если Не КаталогСуществует(КаталогПроекта) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Если Не КаталогСуществует(КаталогИсходныхКодов) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(ФорматЭкспорта) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(ФорматПредставленияОшибки) Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПрочитатьПараметрыВСтроке(Знач СтрокаСПараметром)
	
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.projectKey", ИмяПроекта);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.catalog", КаталогПроекта);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.result", ИмяФайлаРезультата);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.sources", КаталогИсходныхКодов);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.check", ЗначениеПараметра_ВыполнятьПроверку);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.format", ФорматЭкспорта);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.titleError", ФорматПредставленияОшибки);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.relativePathToFiles", ЗначениеПараметра_ОтносительныеПутиКФайлам);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.objectErrors", ЗначениеПараметра_ВыводитьОшибкиОбъектов);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.recreateProject", ЗначениеПараметра_ПересоздатьКонфигурацию);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.exportRules", ЗначениеПараметра_ВыгружатьПравила);
	ЗаполнитьПараметр(СтрокаСПараметром, "acc.fileClassificationError", ФайлКлассификацииОшибок);
	
КонецПроцедуры

Процедура ЗаполнитьПараметр(Знач СтрокаПараметра, Знач ИмяПараметра, ЗначениеПараметра)
	
	текСтрокаВРег = ВРег(СтрокаПараметра);
	
	Если Не СтрНачинаетсяС(текСтрокаВРег, ВРег(ИмяПараметра)) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	позРавно = СтрНайти(СтрокаПараметра, "=");
	
	Если позРавно = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗначениеПараметра = СокрЛП(Сред(СтрокаПараметра, позРавно + 1));
	
	Лог_Отладка("Найден параметр " + ИмяПараметра + " = " + ЗначениеПараметра);
	
КонецПроцедуры

Процедура ПрочитатьФайлПараметров(Знач ПутьКФайлуПараметров)
	
	Лог_Отладка(СтрШаблон("Читаю файл параметров %1", ПутьКФайлуПараметров));
	
	ПутьКФайлуПараметров = АбсолютныйПуть(ПутьКФайлуПараметров);
	
	Если Не фФайлСуществует(ПутьКФайлуПараметров) Тогда
		Лог_Информация(СтрШаблон("Файл параметров %1 не найден.", ПутьКФайлуПараметров));
		Возврат;
	КонецЕсли;
	
	чтениеФайлаПараметров = Новый ТекстовыйДокумент;
	чтениеФайлаПараметров.Прочитать(ПутьКФайлуПараметров, КодировкаТекста.UTF8);
	
	Для ц = 0 По чтениеФайлаПараметров.КоличествоСтрок() Цикл
		
		текСтрока = чтениеФайлаПараметров.ПолучитьСтроку(ц);
		
		ПрочитатьПараметрыВСтроке(текСтрока);
		
	КонецЦикла;
	
	чтениеФайлаПараметров = Неопределено;
	
	ОбеспечитьАбсолютныйПутьККаталогу(КаталогРодитель(ПутьКФайлуПараметров));
	
КонецПроцедуры

Процедура ОбеспечитьАбсолютныйПутьККаталогу(Знач КаталогРодитель)
	
	Если Не ЗначениеЗаполнено(КаталогПроекта) Тогда
		Возврат;
	КонецЕсли;
	
	Лог_Отладка(
		СтрШаблон(
			"Вычисление пути к каталогу проекта. Текущий путь = %1, каталог-родитель = %2",
			КаталогПроекта,
			КаталогРодитель));
	
	Если Не СтрНачинаетсяС(КаталогПроекта, ".") Тогда
		
		Если КаталогСуществует(КаталогПроекта) Тогда
			
			// каталог найден и существует
			
			Лог_Отладка(СтрШаблон("Текущий путь = %1", КаталогПроекта));
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КаталогРодитель) Тогда
		Возврат;
	КонецЕсли;
	
	каталог = КаталогРодитель + ПолучитьРазделительПути() + КаталогПроекта;
	
	Лог_Отладка(СтрШаблон("Вычисление по родителю = %1", каталог));
	
	Если КаталогСуществует(каталог) Тогда
		
		// каталог найден и существует
		
		КаталогПроекта = АбсолютныйПуть(каталог);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПостОбработкаПараметров()
	
	ОбеспечитьАбсолютныйПутьККаталогуИсходныхКодов();
	ОбеспечитьАбсолютныйПутьКФайлуКлассификацииОшибок();
	
	Если ЗначениеЗаполнено(ИмяПроекта) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
			|	Конфигурации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Конфигурации КАК Конфигурации
			|ГДЕ
			|	Конфигурации.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Наименование", ИмяПроекта);
		
		выборка = Запрос.Выполнить().Выбрать();
		
		Если выборка.Следующий() Тогда
			
			Конфигурация = выборка.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	КаталогПроекта = АбсолютныйПуть(КаталогПроекта);
	
	Если ВыводитьОтносительныеПути Тогда
		
		// Заменяем на прямые слешы, т.к. их не придется экранировать в джсоне
		КаталогИсходныхКодов = СтрЗаменить(КаталогИсходныхКодов, "\", "/");
		
	Иначе
		
		КаталогИсходныхКодов = АбсолютныйПуть(КаталогИсходныхКодов);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаталогПроекта)
		И Не СтрЗаканчиваетсяНа(КаталогПроекта, "/") Тогда
		
		КаталогПроекта = КаталогПроекта + "/";
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КаталогИсходныхКодов)
		И Не СтрЗаканчиваетсяНа(КаталогИсходныхКодов, "/") Тогда
		
		КаталогИсходныхКодов = КаталогИсходныхКодов + "/";
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ФорматПредставленияОшибки) Тогда
		ФорматПредставленияОшибки = ФорматОшибкиКодНаименование;
	КонецЕсли;
	
	ВыполнятьПроверку = Значение_Истина(ЗначениеПараметра_ВыполнятьПроверку);
	ВыводитьОтносительныеПути = Значение_Истина(ЗначениеПараметра_ОтносительныеПутиКФайлам);
	ВыводитьОшибкиОбъектов = Значение_Истина(ЗначениеПараметра_ВыводитьОшибкиОбъектов);
	ПересоздатьКонфигурацию = Значение_Истина(ЗначениеПараметра_ПересоздатьКонфигурацию);
	ВыгружатьПравила = Значение_Истина(ЗначениеПараметра_ВыгружатьПравила);
	
	Если ЗначениеЗаполнено(КаталогПроекта) Тогда
		
		Если Не ЗначениеЗаполнено(ИмяФайлаРезультата) Тогда
			
			Если нРег(ФорматЭкспорта) = ФорматЭкспортаGenericIssue Тогда
				ИмяФайлаРезультата = АбсолютныйПуть(КаталогПроекта + ПолучитьРазделительПути() + "acc-generic-issue.json");
			Иначе
				ИмяФайлаРезультата = АбсолютныйПуть(КаталогПроекта + ПолучитьРазделительПути() + "acc-json.json");
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не СтрНайти(ИмяФайлаРезультата, ":") Тогда
			
			// Передан относительный путь	
			ИмяФайлаРезультата = АбсолютныйПуть(КаталогПроекта + ПолучитьРазделительПути() + ИмяФайлаРезультата);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция Значение_Истина(Знач пСтроковоеЗначениеПараметра)
	
	ВРегЗначение = ВРег(пСтроковоеЗначениеПараметра);
	Возврат ВРегЗначение = "TRUE" ИЛИ ВРегЗначение = "1" ИЛИ ВРегЗначение = "ИСТИНА";
	
КонецФункции

Процедура ОбеспечитьАбсолютныйПутьККаталогуИсходныхКодов()
	
	Если ПустаяСтрока(КаталогИсходныхКодов) Тогда
		КаталогИсходныхКодов = "src";
	КонецЕсли;
	
	Лог_Отладка("Вычисление пути к исходникам");
	
	КаталогИсходныхКодов = НайтиКаталогИсходныхКодов();
	
	Лог_Отладка("Текущий каталог исходных кодов: " + КаталогИсходныхКодов);
	
	Лог_Отладка("Уточнение каталога по файлам конфигурации");
	
	найденныеФайлы = НайтиФайлы(КаталогИсходныхКодов, "Configuration.xml", Истина);
	
	Если найденныеФайлы.Количество() > 0 Тогда
		
		ЭтоВыгрузкаEDT = Ложь;
		
		КаталогИсходныхКодов = найденныеФайлы[0].Путь;
		
		Лог_Отладка("Найден файл Configuration.xml: " + найденныеФайлы[0].ПолноеИмя);
		Лог_Отладка("Это выгрузка конфигуратора");
		Лог_Отладка("Каталог исходных файлов: " + КаталогИсходныхКодов);
		Возврат;
		
	КонецЕсли;
	
	найденныеФайлы = НайтиФайлы(КаталогИсходныхКодов, "Configuration.mdo", Истина);
	
	Если найденныеФайлы.Количество() > 0 Тогда
		
		ЭтоВыгрузкаEDT = Истина;
		
		КаталогИсходныхКодов = КаталогРодитель(найденныеФайлы[0].Путь);
		
		Лог_Отладка("Найден файл Configuration.mdo: " + найденныеФайлы[0].ПолноеИмя);
		Лог_Отладка("Это выгрузка EDT");
		Лог_Отладка("Каталог исходных файлов: " + КаталогИсходныхКодов);
		Возврат;
		
	КонецЕсли;
	
	Лог_Информация("Не удалось определить тип выгрузки. Возможно каталог исходных кодов задан не верно.");
	
КонецПроцедуры

Функция НайтиКаталогИсходныхКодов()
	
	ЭтоПолныйПуть = СтрНайти(КаталогИсходныхКодов, ":") > 0;
	
	Если ЭтоПолныйПуть
		И КаталогСуществует(КаталогИсходныхКодов) Тогда
		
		// если каталог исходных был задан не относительный - запрещаем выводить относительные
		ВыводитьОтносительныеПути = Ложь;
		
		Лог_Информация("Каталог исходных файлов по переданному полному пути: " + КаталогИсходныхКодов);
		
		Возврат КаталогИсходныхКодов;
		
	КонецЕсли;
	
	Если Не ЭтоПолныйПуть Тогда
		
		Каталог = КаталогПроекта + ПолучитьРазделительПути()
			+ СтрЗаменить(КаталогИсходныхКодов, "/", ПолучитьРазделительПути());
		
		Если КаталогСуществует(Каталог) Тогда
			
			Возврат Каталог;
			
		Иначе
			
			Лог_Информация("Не удалось определить каталог исходных кодов как [каталог проекта] + [каталог исходных кодов]");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КаталогПроекта;
	
КонецФункции

Процедура ПостОбработкаВывестиПараметрыВСообщения()
	
	Лог_Информация("Имя проекта = " + ИмяПроекта);
	Лог_Информация("Конфигурация = " + Конфигурация + ", код: " + Конфигурация.Код);
	Лог_Информация("Каталог проекта = " + КаталогПроекта);
	Лог_Информация("Файл результата = " + ИмяФайлаРезультата);
	Лог_Информация("Каталог исходников = " + КаталогИсходныхКодов);
	Лог_Информация("Выполнять проверку = " + ВыполнятьПроверку);
	Лог_Информация("Формат экспорта = " + ФорматЭкспорта);
	Лог_Информация("Выгружать правила = " + ВыгружатьПравила);
	Лог_Информация("Файл классификации ошибок = " + ФайлКлассификацииОшибок);
	
КонецПроцедуры

Процедура ОбеспечитьАбсолютныйПутьКФайлуКлассификацииОшибок()
	
	Если ПустаяСтрока(ФайлКлассификацииОшибок) Тогда
		ФайлКлассификацииОшибок = "./FileClassificationError.csv";
	КонецЕсли;
	
	Лог_Отладка("Вычисление пути к файлу кдассификации");
	
	путьКФайлуКлассификации = АбсолютныйПуть(ФайлКлассификацииОшибок);
	
	Если фФайлСуществует(путьКФайлуКлассификации) Тогда
		
		ФайлКлассификацииОшибок = путьКФайлуКлассификации;
		Лог_Отладка("Файл классификации ошибок заполнен по переданному относительному пути: " + ФайлКлассификацииОшибок);
		
	ИначеЕсли СтрНайти(ФайлКлассификацииОшибок, ":") > 0 Тогда // Это полный путь
		
		Если фФайлСуществует(ФайлКлассификацииОшибок) Тогда
			
			Лог_Отладка("Файл классификации ошибок заполнен по переданному полному пути: " + ФайлКлассификацииОшибок);
			
		Иначе
			
			Лог_Отладка("Не удалось найти Файл классификации ошибок по переданному полному пути: " + ФайлКлассификацииОшибок);
			ФайлКлассификацииОшибок = "";
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		РазделительПути = ПолучитьРазделительПути();
		ФайлКлассификацииОшибок = КаталогПроекта
								+ Прав(ФайлКлассификацииОшибок, СтрДлина(ФайлКлассификацииОшибок) - 1);
		ФайлКлассификацииОшибок = СтрЗаменить(ФайлКлассификацииОшибок, "/", РазделительПути);
		ФайлКлассификацииОшибок = СтрЗаменить(ФайлКлассификацииОшибок, "\", РазделительПути);
		
		Если Не фФайлСуществует(ФайлКлассификацииОшибок) Тогда
			
			Лог_Отладка("Не удалось определить Файл классификации ошибок как [каталог проекта] + [Файл классификации ошибок]");
			ФайлКлассификацииОшибок = "";
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Лог_Отладка("Текущий файл классификации ошибок: " + ФайлКлассификацииОшибок);
	
КонецПроцедуры

#КонецОбласти

#Область ФайловыеОперации

Функция АбсолютныйПуть(Знач пПуть)
	
	Файл = Новый Файл(пПуть);
	Возврат СтрЗаменить(Файл.ПолноеИмя, "\", "/"); // Заменяем на прямые слешы, т.к. из не придется экранировать в джсоне
	
КонецФункции

Функция КаталогРодитель(Знач пПуть)
	
	Файл = Новый Файл(пПуть);
	Возврат Файл.Путь;
	
КонецФункции

// Есть глобальный метод ФайлСуществует, но он не проверяет, что это файл
Функция фФайлСуществует(Знач пФайл)
	
	Файл = Новый Файл(пФайл);
	Возврат Файл.Существует() И Файл.ЭтоФайл();
	
КонецФункции

Функция КаталогСуществует(Знач пКаталог)
	
	Файл = Новый Файл(пКаталог);
	Возврат Файл.Существует() И Файл.ЭтоКаталог();
	
КонецФункции

#КонецОбласти

#КонецОбласти