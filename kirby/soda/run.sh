#/bin/bash
rm kirby.db
python db_init.py
sudo python analysis.py
