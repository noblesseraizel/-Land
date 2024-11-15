SELECT 
    c.id AS course_id,                         -- ID курса
    c.name AS course_name,                     -- Название курса
    s.name AS subject,                         -- Название предмета
    s.project AS subject_type,                 -- Тип предмета
    ct.name AS course_type,                    -- Название типа курса
    c.starts_at AS course_start_date,          -- Дата старта курса
    cu.user_id AS student_id,                   -- ID ученика
    us.last_name AS student_last_name,         -- Фамилия ученика
    cit.name AS student_city,                   -- Город ученика
    cu.active AS student_active,                -- Ученик не отчислен с курса
    cu.created_at AS course_opening_date,     -- Дата открытия курса ученику
    FLOOR(DATEDIFF(CURRENT_DATE, cu.created_at) / 30) AS full_months_opened, 
    -- С помощью функции DATEDIFF(CURRENT_DATE, cu.created_at) вычисляем разницу в днях между текущей датой и датой открытия курса в днях
    -- Переводим в месяцы разделяя на 30
    (SELECT COUNT(hw.homework_id)               -- Число сданных ДЗ ученика на курсе
     FROM homework_done hw                      -- Используем подзапрос, чтобы подсчитать только те домашние задания, которые относятся к конкретному курсу
     WHERE hw.user_id = cu.user_id AND hw.course_id = c.id) AS completed_homeworks
FROM 
    courses c
JOIN 
    subjects s ON c.subject_id = s.id           -- Объединение с таблицей subjects
JOIN 
    course_types ct ON c.course_type_id = ct.id -- Объединение с таблицей course_types
JOIN 
    course_users cu ON c.id = cu.course_id      -- Объединение с таблицей course_users
JOIN 
    users us ON cu.user_id = us.id              -- Объединение с таблицей users для получения информации о пользователе
JOIN 
    cities cit ON us.city_id = cit.id           -- Объединение с таблицей cities для получения города
WHERE 
    cu.active = FALSE                            -- Условие, что ученик не отчислен
GROUP BY                                         -- Группируем результаты по всем выбранным полям
    c.id, c.name, s.project, ct.name, ct.name, c.starts_at, 
    cu.user_id, us.last_name, cit.name, cu.active, cu.created_at 

ORDER BY 
    c.id                                         -- Сортируем результаты  по ID курса
