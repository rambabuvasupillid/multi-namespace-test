
These steps are successfully tested for following test scenario
----------------------------------------------------------------


A user, Andrea, needs to be able to access a secret, called db_rsa_key, in a Transit secrets engine in the root namespace of the Vault.
That same user, Andrea, also needs to have admin privileges (able to add new secrets engines, etc.) on a child namespace, called ci.
Andrea should authenticate via her membership in either of the following:
* GitHub team
* LDAP group.
Solution:
Make a policy in the root namespace that gives access to the db_rsa_key.
Make another policy in the ci namespace that gives admin rights on the ci namespace, for any operations except for creating or deleting Vault policies.
The next step is to find a way to restrict the user, Andrea, from giving herself any sudo operations in the Vault namespace, while still allowing as much access as possible otherwise. Please send me your ideas on how to do this.
If you would like to add an additional improvement to this, restrict access to the Namespace to 09:00-17:00 CST hours only.


