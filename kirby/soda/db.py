import sqlite3


conn = sqlite3.connect('kirby.db')
c = conn.cursor()
def store_pairs(one, two):
	if "'" in one or "'" in two:
		return
	if one != two:
		c.execute("SELECT * FROM soda WHERE lib1 = '" + one + "' and lib2 = '" + two + "'")
		rows = c.fetchall()
		if rows:
			num = rows[0][2] + 0.5
			conn.execute("UPDATE soda set num = " + str(num) + " where lib1 = '" + one + "' and lib2 = '" + two + "'")
			conn.commit()
			return
		c.execute("SELECT * FROM soda WHERE lib1 = '" + two + "' and lib2 = '" + one + "'")
		rows = c.fetchall()
		if rows:
			num = rows[0][2] + 0.5
			conn.execute("UPDATE soda set num = " + str(num) + " where lib1 = '" + two + "' and lib2 = '" + one + "'")
			conn.commit()
			return
		#insert new copy
		conn.execute("INSERT INTO soda (lib1, lib2, num) VALUES ('" + one + "', '" + two + "', 0.5)")
		conn.commit()

def print_all():
	c.execute("SELECT * FROM soda ORDER BY num DESC")
	rows = c.fetchall()
	return rows
