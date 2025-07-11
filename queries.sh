#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) from games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) from games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo  "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) from games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo  "$($PSQL "SELECT AVG(winner_goals + opponent_goals) from games")"

echo -e "\nMost goals scored in a single game by one team:"
echo  "$($PSQL "SELECT MAX(winner_goals) from games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo  "$($PSQL "SELECT count(game_id) from games where winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo  "$($PSQL "SELECT name from teams where team_id = (select winner_id from games where year = 2018 and round like 'Final')")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT w.name from games as g join teams as w on g.winner_id = w.team_id where year = 2014 and round like 'Eighth-Final' union select o.name from games as g join teams as o on g.opponent_id = o.team_id  where year = 2014 and round like 'Eighth-Final' order by name asc")"

echo -e "\nList of unique winning team names in the whole data set:"
echo  "$($PSQL "SELECT distinct(w.name) from games as g join teams as w on g.winner_id = w.team_id where year = 2014 or year = 2018 order by w.name asc")"

echo -e "\nYear and team name of all the champions:"
echo  "$($PSQL "SELECT games.year, teams.name from teams join games on games.winner_id = teams.team_id where (year = 2018 or year = 2014) and round like 'Final' order by games.year")"

echo -e "\nList of teams that start with 'Co':"
echo  "$($PSQL "SELECT name from teams where name like 'Co%'")"
