select first_name, last_name, calc_worktype.title, SUM(count) as "Кол-во", SUM(duration) as "Время", SUM(count)/SUM(duration) as "Производительность"
from calc_workout
join calc_employee on calc_employee.id=calc_workout.employee_id
join calc_workdata on calc_workdata.id=calc_workout.work_data_id
join calc_worktype on calc_worktype.id=calc_workdata.work_type_id
join calc_order on calc_order.id=calc_workdata.order_id
where
  (calc_order.start_date >= '2012-01-01'
  and
  calc_order.start_date <= '2012-12-01')
  or
  (calc_order.end_date >= '2012-01-01'
  and
  calc_order.end_date >= '2012-12-01')
GROUP BY first_name, last_name, calc_worktype.title
ORDER BY calc_worktype.title