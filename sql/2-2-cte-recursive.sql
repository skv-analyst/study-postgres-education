/* Создаем данные */

create table if not exists parts
( part text,
  sub_part text,
  quantity int not null,
  primary key (part, sub_part)
);

insert into parts (part, sub_part, quantity) values
('самолет', 'планер', 1),
('самолет', 'силовая установка', 1),
('планер', 'фюзеляж', 1),
('планер', 'крыло', 2),
('планер', 'хвостовое оперение', 1),
('планер', 'шасси', 1),
('фюзеляж', 'кабина экипажа', 1),
('фюзеляж', 'пассажирский салон', 1),
('силовая установка', 'двигатель', 2),
('шасси', 'передняя стойка', 1),
('шасси', 'основная стойка', 2),
('передняя стойка', 'колесо', 2),
('основная стойка', 'колесо', 4),
('колесо', 'подшипник', 2);


/* Можно ли жить без рекурсии? */
with
    level_1 as (
        select sub_part, quantity
        from parts
        where part = 'самолет'
    ),

    level_2 as (
        select l2.sub_part, l1.quantity * l2.quantity AS quantity
        from level_1 as l1
        inner join parts as l2 on l1.sub_part = l2.part
    ),

    level_3 as (
        select l3.sub_part, l2.quantity * l3.quantity as quantity
        from level_2 as l2
        inner join parts as l3 on l2.sub_part = l3.part
    ),

    level_4 as (
        select l4.sub_part, l3.quantity * l4.quantity as quantity
        from level_3 as l3
        inner join parts as l4 on l3.sub_part = l4.part
    ),

    level_5 as (
        select l5.sub_part, l4.quantity * l5.quantity as quantity
        from level_4 as l4
        inner join parts as l5 on l4.sub_part = l5.part
    ),

    levels as (
        select * from level_1
        union all
        select * from level_2
        union all
        select * from level_3
        union all
        select * from level_4
        union all
        select * from level_5
    )

select sub_part, sum(quantity)
from levels
group by sub_part
order by sub_part;



/* Можно ли жить с рекурсией? */
with
    recursive included_parts(part, sub_part, quantity) as (
        select part, sub_part, quantity
        from parts
        where part = 'самолет'

        union all

        select p.part, p.sub_part, p.quantity * ip.quantity
        from included_parts as ip
        inner join parts as p on p.part = ip.sub_part
    )

select sub_part, sum(quantity)
from included_parts
group by sub_part
order by sub_part;

/* Добавим маршрутизации */
with
    recursive included_parts(part, sub_part, quantity,  iteration, path_to_sub_part) as (
        select part, sub_part, quantity,
               1,
               part || ' -> ' || sub_part || ' (x' || quantity || ')'
        from parts
        where part = 'самолет'

        union all

        select p.part, p.sub_part, p.quantity * ip.quantity,
               iteration + 1,
               ip.part || ' -> ' || ip.sub_part || ' (x' || ip.quantity || ')' ||
                   case when p.part is not null
                        then ' -> ' || p.sub_part || ' (x' || p.quantity || ')'
                        else ' -> составных частей нет'
                   end
        from included_parts ip
        left join parts as p on p.part = ip.sub_part
        where ip.part is not null
    ),

    included_parts2(part, sub_part, quantity,  iteration, path_to_sub_part) as (
        select part, sub_part, quantity,
               1,
               part || ' -> ' || sub_part || ' (x' || quantity || ')'
        from parts
        where part = 'самолет'

        union all

        select coalesce(p.part, ip.sub_part) AS part, p.sub_part, p.quantity * ip.quantity,
               iteration + 1,
               ip.part || ' -> ' || ip.sub_part || ' (x' || ip.quantity || ')' ||
                   case when p.part is not null
                        then ' -> ' || p.sub_part || ' (x' || p.quantity || ')'
                        else ' -> составных частей нет'
                   end
        from included_parts2 ip
        left join parts as p on p.part = ip.sub_part
        where ip.sub_part is not null
    )


select iteration, path_to_sub_part, part, sub_part, quantity
from included_parts2
order by iteration;

