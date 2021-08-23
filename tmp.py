import random 

a = 400
b = 800

def get_rate():
	global a,b
	return a/b
def show():
	global a,b
	print(a,b, get_rate())

show()

def add_amount(am):
	global a,b
	print("exchanged A", am, "to B", int(b*am/a))
	b += int(b/a*am)
	a += am

def remove_amount(am):
	global a,b
	print("exchanged B", am, "to A", int(a*am/b))
	a -= int(a/b*am)
	b -= am




for i in range(100):
	add_amount(200+random.randint(1,100)*10)
	show()
	remove_amount(100+random.randint(1,100)*10)
	show()

