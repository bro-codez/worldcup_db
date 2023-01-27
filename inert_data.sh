#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo -e "\n$($PSQL "truncate teams, games;")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    WINNER_ID="$($PSQL "select team_id from teams where name='$WINNER'")"
    if [[ -z $WINNER_ID ]]
    then
      WINNER_INSERTION="$($PSQL "insert into teams(name) values('$WINNER');")"
      if [[ $WINNER_INSERTION = 'INSERT 0 1' ]]
      then
        WINNER_ID="$($PSQL "select team_id from teams where name='$WINNER'")"
        echo -e "\nTeam $WINNER inserted."
      fi
    fi
    OPPONENT_ID="$($PSQL "select team_id from teams where name='$OPPONENT'")"
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_INSERTION="$($PSQL "insert into teams(name) values('$OPPONENT');")"
      if [[ $OPPONENT_INSERTION = 'INSERT 0 1' ]]
      then
        OPPONENT_ID="$($PSQL "select team_id from teams where name='$OPPONENT'")"
        echo -e "\nTeam $OPPONENT inserted."
      fi
    fi
    # echo -e "\n$YEAR,$ROUND,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS"
    GAME_INSERTION="$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")"
    if [[ $GAME_INSERTION = 'INSERT 0 1' ]]
    then
      echo -e "\nGame inserted."
    fi
  fi
done