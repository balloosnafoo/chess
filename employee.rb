
class Employee
  attr_reader :salary

  def initialize(name, salary, title, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    salary * multiplier
  end

  def employees
    []
  end

end

class Manager < Employee
  attr_reader :employees

  def initialize(name, salary, title, boss, employees)
    super(name, salary, title, boss)
    @employees = employees
  end

  def bonus(multiplier)
    (@employees.inject(0) do |sum, employee|
      sum + employee.employees.inject(0) do |sub_sum, sub_employee|
        sub_sum + sub_employee.salary
      end + employee.salary
    end) * multiplier
  end

end

if __FILE__ == $PROGRAM_NAME
  d = Employee.new("dav", 10000, "TA", "Darren")
  s = Employee.new("shawna", 12000, "TA", "Darren")
  darren = Manager.new("shawna", 78000, "TA Manager", "Ned", [d, s])
  n = Manager.new("ned", 1000000, "founder", nil, [darren])
  p n.bonus(5)
end
