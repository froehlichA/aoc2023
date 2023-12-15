#include <iostream>
#include <fstream>
#include <string>
#include <tuple>
#include <map>
using namespace std;

enum Direction: int
{
	Up = 0,
	Right = 1,
	Down = 2,
	Left = 3
};

class Coord
{
	public:
		int x = 0;
		int y = 0;
		Coord() {};
		Coord(int x, int y) : x(x), y(y) {};
		bool operator==(const Coord& rhs) const;
		Coord inDirection(Direction dir) const;
		std::tuple<Coord, Coord> getNeighbors(char map[140][140]) const;
};

bool Coord::operator==(const Coord& rhs) const
{
	return x == rhs.x && y == rhs.y;
}

Coord Coord::inDirection(Direction dir) const
{
	switch(dir) {
		case Direction::Up: return Coord(x, y-1);
		case Direction::Right: return Coord(x+1, y);
		case Direction::Down: return Coord(x, y+1);
		case Direction::Left: return Coord(x-1, y);
	}
	return Coord(x, y);
}

std::tuple<Coord, Coord> Coord::getNeighbors(char map[140][140]) const
{
	char cur = map[y][x];
	switch (cur) {
		case '|': return {this->inDirection(Direction::Up), this->inDirection(Direction::Down)};
		case '-': return {this->inDirection(Direction::Left), this->inDirection(Direction::Right)};
		case 'L': return {this->inDirection(Direction::Up), this->inDirection(Direction::Right)};
		case 'J': return {this->inDirection(Direction::Up), this->inDirection(Direction::Left)};
		case '7': return {this->inDirection(Direction::Left), this->inDirection(Direction::Down)};
		case 'F': return {this->inDirection(Direction::Right), this->inDirection(Direction::Down)};
		case 'S': break;
		default: return {};
	}

	std::tuple<Coord, Coord> coords;
	int i = 0;
	for (int dir_i = 0; dir_i < 4; dir_i++)
	{
		Direction dir = static_cast<Direction>(dir_i);
		Coord coord = this->inDirection(dir);
		std::tuple<Coord, Coord> ret = coord.getNeighbors(map);
		Coord fst = std::get<0>(ret);
		Coord snd = std::get<1>(ret);
		if (std::get<0>(ret) == *this || std::get<1>(ret) == *this) {
			if (i == 0) {
				std::get<0>(coords) = coord;
			} else {
				std::get<1>(coords) = coord;
			}
			i++;
		}
	}
	return coords;	
}

void run(std::map<std::tuple<int, int>, int> &cache, char map[140][140], Coord current, int depth)
{
	std::tuple<int, int> coord = {current.x, current.y};
	if(cache.count(coord) && cache[coord] < depth) return;

	cache[coord] = depth;
	auto neighbors = current.getNeighbors(map);
	run(cache, map, std::get<0>(neighbors), depth + 1);
	run(cache, map, std::get<1>(neighbors), depth + 1);
}

int main()
{
	char input[140][140];
	Coord s;

  	std::ifstream input_file ("input.txt");
  	std::string line;
 	int row = 0; 
  	if (input_file.is_open()) {
  		while (input_file) {
  			std::getline(input_file, line);
  			for(std::string::size_type col = 0; col < line.size(); col++) {
  				input[row][col] = line[col];
  				if(line[col] == 'S') {
  					s = Coord(col, row);
  				}
  			}
  			row++;
  		}
  	}

	// Algorithm
	std::map<std::tuple<int, int>, int> map;
	run(map, input, s, 0);
	int biggestDepth = 0;
	for (const auto& [key, value] : map)
	{
		if(value > biggestDepth) biggestDepth = value;
	}
	std::cout << biggestDepth << "\n";
	
  	return 0;
}
