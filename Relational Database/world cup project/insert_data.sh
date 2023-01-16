#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# read data from games.csv
INSERT_TEAM(){
  # check if team exists
  TEAM_ID=$($PSQL "select team_id from teams where name='$1'")
  # if not
  if [[ -z $TEAM_ID ]]
  then
    # insert team
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$1')")
  fi
}
cat games.csv | while IFS="," read YEAR ROUND WINNER_TEAM OPPONENT_TEAM WINNER_GOALS OPPONENT_GOALS
do
  # ignore the first line
  if [[ ! $YEAR == 'year' ]]
  then
    INSERT_TEAM "$WINNER_TEAM"
    INSERT_TEAM "$OPPONENT_TEAM"
    WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER_TEAM'")
    OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT_TEAM'")
    INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done