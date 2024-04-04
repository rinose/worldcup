#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

db_name="worldcup"
host="localhost"
username="freecodecamp"
password=""

teams_table="teams"
games_table="games"


#sql = "insert into $teams_table (name) values ('$team_name');"
#PGPASSWORD=$password psql -h $host -U $user -d $db_name -c "$sql"

# Path to the CSV file
csv_file="games.csv"

# Read the CSV file line by line
# game_id | year | round | winner_id | opponent_id | winner_goals | opponent_goals 
# while IFS=',' read -r column1 column2 column3 column4 column5 column6
# do
#     if [ "$column3" != "winner" ]; then
#       echo "Column3: $column3"
#       echo "Column4: $column4"
#       sql="insert into $teams_table (name) values ('$column3');"
#       $PSQL "$sql"
#       sql="insert into $teams_table (name) values ('$column4');"
#       $PSQL "$sql"
#     fi
# done < "$csv_file"

# fill games 
# game_id | year | round | winner_id | opponent_id | winner_goals | opponent_goals 
while IFS=',' read -r column1 column2 column3 column4 column5 column6
do
    if [ "$column3" != "winner" ]; then
      echo "Column3: $column3"
      echo "Column4: $column4"
      winner_id=$($PSQL "select team_id from teams where name='$column3'")
      opponent_id=$($PSQL "select team_id from teams where name='$column4'")
      sql="insert into $games_table (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($column1,'$column2',$winner_id,$opponent_id,$column5,$column6);"
      echo $sql
      $PSQL "$sql"
    fi
done < "$csv_file"
