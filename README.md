Logic is largely inaccessible to people. It takes a lot of time and thought to
break down an argument into its components, to evaluate its cogency. Most
people don't have the skill to do this. Even among those who do, it is still
challenging to understand an argument on a logical basis.

This app facilitates logical discussion and debate, with the goal of
bringing people together when they disagree, and help them reach mutual
understanding.

# Setup

Configure PostgreSQL
```
cp config/database.yml.example config/database.yml
createuser -d debate
createdb debate_dev -O debate
createdb debate_test -O debate
rake db:migrate
rake db:test:prepare
```
