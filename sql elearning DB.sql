
DROP DATABASE IF EXISTS elearning;
CREATE DATABASE elearning;
USE elearning;

-- Table1  learners creation 
CREATE TABLE learners (
  learner_id INT PRIMARY KEY,
  full_name VARCHAR(100),
  country VARCHAR(50)
);
-- Table 2 courses creation 
CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  course_name VARCHAR(100),
  category VARCHAR(50),
  unit_price DECIMAL(10,2)
);
-- Table 3 purchases creation 
CREATE TABLE purchases (
  purchase_id INT PRIMARY KEY,
  learner_id INT,
  course_id INT,
  quantity INT,
  purchase_date DATE,
  FOREIGN KEY (learner_id) REFERENCES learners(learner_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- inserting values into tables 
-- inserting value into learners table
INSERT INTO learners (learner_id, full_name, country) VALUES
(1, 'Asha R', 'India'),
(2, 'Ravi Kumar', 'India'),
(3, 'Maya Nayir', 'UK'),
(4, 'Ramesh Tilak ', 'USA'),
(5, 'Ganesh kumar', 'Canada');

-- viewing inserted values of learners table
select * from learners;

-- inserting into courses table
INSERT INTO courses (course_id, course_name, category, unit_price) VALUES
(1, 'Intro to SQL', 'Data', 1999.00),
(2, 'EXCEL FOR Data Analytics ', 'Data', 3499.00),
(3, 'Machine Learning Basics', 'AI', 4999.00),
(4, 'Programming in Python ', 'Programming', 7999.00),
(5, 'AI Driven Data Analytics 101', 'Data', 2999.00);

-- viewing inserted values of courses table 
select * from courses;

-- inserting values into purchases table
INSERT INTO purchases (purchase_id, learner_id, course_id, quantity, purchase_date) VALUES
(1001, 1, 1, 1, '2025-01-10'),
(1002, 1, 3, 1, '2025-01-12'),
(1003, 2, 1, 2, '2025-02-05'),
(1004, 3, 5, 1, '2025-02-10'),
(1005, 4, 4, 1, '2025-03-15'),
(1006, 4, 3, 2, '2025-03-20'),
(1007, 5, 2, 1, '2025-03-22'),
(1008, 2, 3, 1, '2025-03-25');

-- viewing inserted values of purchases table 
select* from purchases;

-- Using SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN 
-- inner join to find Only learners who purchased something
SELECT
  p.purchase_id,
  l.full_name AS learner_name,
  c.course_name AS course_name,
  c.category AS category,
  p.quantity AS quantity,
  FORMAT(c.unit_price, 2) AS unit_price,
  FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
  p.purchase_date AS purchase_date
FROM purchases p
INNER JOIN learners l ON p.learner_id = l.learner_id
INNER JOIN courses c ON p.course_id = c.course_id
ORDER BY total_amount DESC;
-- LEFT JOIN  to Show ALL learners  and  their purchase details
SELECT
  l.learner_id,
  l.full_name AS learner_name,
  c.course_name,
  c.category,
  p.quantity,
  FORMAT(c.unit_price, 2) AS unit_price,
  FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
  p.purchase_date
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id
ORDER BY learner_name ASC;
-- RIGHT JOIN to  Show ALL courses  and any learners who purchased
SELECT 
  c.course_id,
  c.course_name,
  c.category,
  l.full_name AS learner_name,
  p.quantity,
  FORMAT(c.unit_price, 2) AS unit_price,
  FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
  p.purchase_date
FROM purchases p
RIGHT JOIN courses c ON p.course_id = c.course_id
LEFT JOIN learners l ON p.learner_id = l.learner_id
ORDER BY c.course_name ASC;

-- Analytical queries
-- Q1 learners name with totsl spending and country 
SELECT 
    l.learner_id,
    l.full_name AS learner_name,
    l.country ,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c   ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name,l.country
ORDER BY SUM(p.quantity * c.unit_price) DESC;

-- Q2. Find the top 3 most purchased courses based on total quantity sold.
SELECT
  c.course_id,
  c.course_name,
  c.category,
  SUM(p.quantity) AS total_quantity_sold
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name, c.category
ORDER BY total_quantity_sold DESC
LIMIT 3;

-- Q3. Show each course category’s total revenue and  number of unique learners who purchased from that category
SELECT
    c.course_id,
    c.course_name,
    c.category,
    SUM(p.quantity * c.unit_price) AS revenue
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name,c.category
ORDER BY revenue DESC;

 
 -- Q4. List all learners who have purchased courses from more than one category.
SELECT
  l.learner_id,
  l.full_name,
  COUNT(DISTINCT c.category) AS distinct_categories
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.learner_id, l.full_name
HAVING COUNT(DISTINCT c.category) > 1;

-- Q5. Identify courses that have not been purchased at all.
SELECT
  c.course_id,
  c.course_name,
  c.category
FROM courses c
LEFT JOIN purchases p ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;

-- Additional query to view the whole dataset 
SELECT
  (SELECT COUNT(*) FROM learners) AS total_learners,
  (SELECT COUNT(*) FROM courses) AS total_courses,
  (SELECT COUNT(*) FROM purchases) AS total_purchases,
  SUM(p.quantity * c.unit_price) AS total_revenue
FROM purchases p
JOIN courses c ON p.course_id = c.course_id;
