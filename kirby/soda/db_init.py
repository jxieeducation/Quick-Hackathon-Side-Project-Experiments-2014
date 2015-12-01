import sqlite3

conn = sqlite3.connect('kirby.db')
c = conn.cursor()

c.execute('''CREATE TABLE soda(lib1 text, lib2 text, num real)''')
conn.commit()
