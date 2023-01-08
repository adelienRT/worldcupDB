#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# echo $($PSQL ";")
# Delete every entries into existant tables
echo $($PSQL "TRUNCATE teams,games;")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART;")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART;")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

  if [[ $WINNER != winner ]]
    then

     #Insert the winner names into the table, after checking if it doesn't exist
    TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER';")
    if [[ -z $TEAM_ID ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi
    # Get the winner number
    WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER';")

     #Insert the opponent names into the table, after checking if it doesn't exist
    TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT';")
    if [[ -z $TEAM_ID ]]
    then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi

    # Get the opponent number
    OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT';")

    # insert values into games
    echo $($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")

  fi


done

echo $($PSQL "SELECT COUNT(*) FROM teams") "teams have been added"
echo $($PSQL "SELECT COUNT(*) FROM games") "games have been added"



