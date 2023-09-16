﻿if GetLocale() ~= "ruRU" then return end

local L


--------------------
--Разрушенные залы--
--------------------

----------------------------------
--Главный чернокнижник Пустоклят--
----------------------------------
L = DBM:GetModLocalization(566)

-------------------------
--Кровавый страж Порунг--
-------------------------
L = DBM:GetModLocalization(728)

-----------------------
--О'мрогг Завоеватель--
-----------------------
L = DBM:GetModLocalization(568)

-------------------------
--Вождь Каргат Острорук--
-------------------------
L = DBM:GetModLocalization(569)

-----------
--Узилище--
-----------

-------------------
--Менну Предатель--
-------------------
L = DBM:GetModLocalization(570)

------------------
--Рокмар Трескун--
------------------
L = DBM:GetModLocalization(571)

---------
--Зыбун--
---------
L = DBM:GetModLocalization(572)

---------
--Trash--
---------
L = DBM:GetModLocalization("TSPTrash")

L:SetGeneralLocalization({
	name = "Трэш Узилища"
})

-----------------
--Гробницы Маны--
-----------------

--------------
--Пандемоний--
--------------
L = DBM:GetModLocalization(534)

-----------
--Таварок--
-----------
L = DBM:GetModLocalization(535)

----------------
--Принц Шаффар--
----------------
L = DBM:GetModLocalization(537)

-------
--Йор--
-------
L = DBM:GetModLocalization(536)

---------------
--Черные топи--
---------------

---------------------------
--Повелитель времени Дежа--
---------------------------
L = DBM:GetModLocalization(552)

------------
--Темпорус--
------------
L = DBM:GetModLocalization(553)

---------
--Эонус--
---------
L = DBM:GetModLocalization(554)

L:SetMiscLocalization({
    AeonusFrenzy	= "%s приходит в бешенство!"
})

--------------------
--Таймеры порталов--
--------------------
L = DBM:GetModLocalization("PT")

L:SetGeneralLocalization({
	name = "Таймеры порталов (ПВ)"
})

L:SetWarningLocalization({
    WarnWavePortalSoon	= "Скоро новый портал",
    WarnWavePortal		= "Портал %d",
    WarnBossPortalSoon	= "Скоро прибытие босса",
    WarnBossPortal		= "Прибытие босса"
})

L:SetTimerLocalization({
	TimerNextPortal		= "Портал %d"
})

L:SetOptionLocalization({
    WarnWavePortalSoon	= "Показывать предварительное предупреждение для нового портала",
    WarnWavePortal		= "Показать предупреждение для нового портала",
    WarnBossPortalSoon	= "Показать предварительное предупреждение о прибытии босса",
    WarnBossPortal		= "Показать предупреждение о прибытии босса",
	TimerNextPortal		= "Показать таймер для номера портала"
})

L:SetMiscLocalization({
	PortalCheck			= "Врат Времени открыто: (%d+)/18",
	Shielddown			= "Нет! Будь проклята эта жалкая смертная оболочка!"
})

------------
--Аркатрац--
------------

---------------------
--Зерекет Бездонный--
---------------------
L = DBM:GetModLocalization(548)

--------------------------
--Даллия Глашатай Судьбы--
--------------------------
L = DBM:GetModLocalization(549)

---------------------------
--Провидец Гнева Соккорат--
---------------------------
L = DBM:GetModLocalization(550)

------------------------
--Предвестник Скайрисс--
------------------------
L = DBM:GetModLocalization(551)

L:SetMiscLocalization({
	Split	= "Мы бесчисленны, как звезды! Мы заполоним вселенную!"
})

---------------------
--Терраса Магистров--
---------------------

-------------------------
--Селин Огненное Сердце--
-------------------------
L = DBM:GetModLocalization(530)

-------------
--Вексалиус--
-------------
L = DBM:GetModLocalization(531)

------------------
--Жрица Делрисса--
------------------
L = DBM:GetModLocalization(532)

L:SetMiscLocalization({
--	DelrissaPull	= "Уничтожьте их.",
	DelrissaEnd		= "На это... я... не рассчитывала..."
})

----------------------------------------
--Кель'тас Солнечный Скиталец (группа)--
----------------------------------------
L = DBM:GetModLocalization(533) --"Kael"

L:SetGeneralLocalization({
	name = "Кель'тас Солнечный Скиталец (группа)"
})

L:SetMiscLocalization({
	KaelP2	= "Я переверну ваш мир... вверх... дном."
})
