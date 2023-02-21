-- List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employee e
JOIN salaries s ON e.emp_no = s.emp_no;
	-- Alternative solution using subquery
	SELECT emp_no, last_name, first_name, sex, (
		SELECT salary 
		FROM salaries 
		WHERE salaries.emp_no = employee.emp_no) AS salary
	FROM employee;


-- List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employee
WHERE EXTRACT('Year' FROM hire_date) = 1986;
	

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employee e ON dm.emp_no = e.emp_no;
	-- Alternative solution using subquery
	SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name 
	FROM dept_manager dm, departments d, employee e
	WHERE dm.dept_no = d.dept_no AND dm.emp_no = e.emp_no AND dm.emp_no IN (
		SELECT emp_no 
		FROM employee)
	ORDER BY dm.dept_no;


-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT d.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no 
JOIN employee e ON de.emp_no = e.emp_no;
	-- Alternative solution using subqueries
	SELECT 
		e.emp_no, 
		e.last_name, 
		e.first_name, (
		SELECT dept_name 
		FROM departments 
		WHERE dept_no = (
			SELECT dept_no
			FROM dept_emp 
			WHERE emp_no = e.emp_no)) 
		AS dept_name, (
		SELECT dept_no 
		FROM dept_emp 
		WHERE emp_no = e.emp_no) 
		AS dept_no
	FROM 
		employee e
	WHERE 
		e.emp_no IN (
			SELECT emp_no 
			FROM dept_emp)
	ORDER BY e.emp_no;


-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employee
WHERE first_name = 'Hercules' AND last_name LIKE ('B%');


-- List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.emp_no, e.last_name, e.first_name
FROM employee e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';
	-- Alternative solution using subqueries
	SELECT e.emp_no, e.last_name, e.first_name
	FROM employee e
	WHERE e.emp_no IN (
		SELECT de.emp_no
		FROM dept_emp de
		WHERE de.dept_no IN (
			SELECT d.dept_no
			FROM departments d
			WHERE d.dept_name = 'Sales'));
		

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employee e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');
	-- Alternative solution using subqueries and UNION
	SELECT emp_no, last_name, first_name, dept_name
	FROM employee
	WHERE emp_no IN (
		SELECT emp_no
		FROM dept_emp
		WHERE dept_no = (
			SELECT dept_no
			FROM departments
			WHERE dept_name = 'Sales'))
	UNION
	SELECT emp_no, last_name, first_name, dept_name
	FROM employee
	WHERE emp_no IN (
		SELECT emp_no
		FROM dept_emp
		WHERE dept_no = (
			SELECT dept_no
			FROM departments
			WHERE dept_name = 'Development'))
	ORDER BY emp_no;


-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) as frequency
FROM employee
GROUP BY last_name
ORDER BY frequency DESC;