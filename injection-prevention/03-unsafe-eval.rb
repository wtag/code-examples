# Assume `Passport` and `IDCard` are existing models in the database
# Assume frontend wants to display all passports or id cards in tabs

# Bad:
#  Allows an attacker to do anything:
#  ?document_type=CreditCard.destroy_all;Passport
list = eval("#{params[:document_type]}.all")

# Good:
#  Use mapping to identify what should be run
DOCUMENT_TYPE_MAPPING = { passport: Passport, id_card: IDCard }

document_type = DOCUMENT_TYPE_MAPPING.fetch(params[:document_type])

list = document_type.all
