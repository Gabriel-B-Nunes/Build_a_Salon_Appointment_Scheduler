#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

#1-quais os dados necessários?
#service_id, phone_number, time
#2-o que fazer com esses dados?
#exibir menu padrão OK
#perguntar service id, caso não ache retornar ao menu com mensagem OK
#perguntar numero de telefone para selecionar dados do customer, caso não ache perguntar numero e nome para cadastrar customer OK
#perguntar horário com mensagem exibindo service e name
#agendar no sql
#exibir mensagem para confirmar agendamento com service, time e name

MAIN_MENU () {
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  read SERVICE_ID_SELECTED
}

CUSTOMER_SELECTOR () {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  PHONE_RESULT="$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")"
  if [[ -z $PHONE_RESULT ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo $($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
}

TIME_SELECTOR () {
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  echo $($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
}

SALON_APPOINTMENT () {
  CUSTOMER_SELECTOR
  TIME_SELECTOR
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU

if [[ "$SERVICE_ID_SELECTED" -le 5 ]]
then
  SALON_APPOINTMENT
else
  echo -e "\nI could not find that service. What would you like today?"
  MAIN_MENU
fi
