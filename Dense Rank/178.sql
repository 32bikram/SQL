# Write your MySQL query statement below
select score, dense_rank() 
over (order by score DESC) as 'rank'
from Scores;

DENSE_RANK() assigns a number to each distinct salary level.
OVER() tells SQL:
"How should I calculate this ranking?"
