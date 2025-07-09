#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo "Truncating tables..."
$($PSQL "TRUNCATE teams, games RESTART IDENTITY;") # RESTART IDENTITY resets serial IDs
echo "Tables truncated."
# Enter csv file, change delimeter from " " to "," and create to input variables(year, round, winner, opponent, winner_goals, opponent_goals)

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $YEAR != year ]]
then

  # Four below steps are the process to insert new data and create an unique id for each inserted one:
  #Step 1 check team_id from teams table, if there is no value retrieved, go to step 2:
  TEAM_WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  TEAM_OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
  if [[ -z $TEAM_WINNER_ID ]]

  #Step 2a if TEAM_WINNER_ID returns an empty value, add the name of winner into name column:
  then
    INSERT_TEAMS_NAME=$($PSQL "insert into teams(name) values('$WINNER')")
    if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
    then
      echo "Inserted into teams: $WINNER"
    fi
  fi
  if [[ -z $TEAM_OPPONENT_ID ]]

  #step 2b if TEAM_OPPONENT_ID returns an empty value, add the name of opponent team into name column:
  then
    INSERT_OPPONENT_NAME=$($PSQL "insert into teams(name) values('$OPPONENT')")
    if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
    then
      echo "Inserted into teams: $OPPONENT"
    fi
  fi

  
  
fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $YEAR != year ]]
then
  #Step 3 get team_winner_id and team_opponent_id
  TEAM_WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  TEAM_OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
  #Step 4 insert remainers into games table
  INSERT_VALUE=$($PSQL "insert into games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $TEAM_WINNER_ID, $TEAM_OPPONENT_ID)")
fi
done


