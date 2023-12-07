let 
	nixpkgs = import <nixpkgs> {};
	lib = nixpkgs.lib;
in with builtins; with lib; rec {
	countOccurences = list:
		if (length list == 0)
		then {}
		else let
			prev = countOccurences (tail list);
			key = head list;
			prevValue = if (hasAttrByPath [key] prev) then (getAttr key prev) else 0;
		in prev // (setAttrByPath [key] (prevValue + 1));
	findIndex' = e: i: list: a:
		if (length list == 0)
		then i
		else if (head list == e) then a else (findIndex' e i (tail list) (a + 1));
	findIndex = e: i: list: findIndex' e i list 0;
	mapWithIndex' = fn: list: a:
		if (length list == 0)
		then []
		else [(fn (head list) a)] ++ (mapWithIndex' fn (tail list) (a + 1));
	mapWithIndex = fn: list: mapWithIndex' fn list 0;

	getCombinations = cards: sort (a: b: a > b) (attrValues (countOccurences (stringToCharacters cards)));
	isFiveOfAKind = cards: (getCombinations cards) == [ 5 ];
	isFourOfAKind = cards: (getCombinations cards) == [ 4 1 ];
	isFullHouse = cards: (getCombinations cards) == [ 3 2 ];
	isThreeOfAKind = cards: (getCombinations cards) == [ 3 1 1 ];
	isTwoPair = cards: (getCombinations cards) == [ 2 2 1 ];
	isOnePair = cards: (getCombinations cards) == [ 2 1 1 1 ];
	strengthOfHand = cards:
		if (isFiveOfAKind cards) then 7 else
		if (isFourOfAKind cards) then 6 else
		if (isFullHouse cards) then 5 else
		if (isThreeOfAKind cards) then 4 else
		if (isTwoPair cards) then 3 else
		if (isOnePair cards) then 2 else 1;
	strengthOfCard = card: findIndex card 0 ["2" "3" "4" "5" "6" "7" "8" "9" "T" "J" "Q" "K" "A"];
	cmpCards = a: b: let
		aStr = strengthOfCard (head a);
		bStr = strengthOfCard (head b);
	in if (aStr == bStr) then (cmpCards (tail a) (tail b)) else aStr < bStr;
	cmpHand = a: b: let
		aStr = strengthOfHand a;
		bStr = strengthOfHand b;
	in if (aStr == bStr) then (cmpCards (stringToCharacters a) (stringToCharacters b)) else (aStr < bStr);

	input = readFile "/home/alex/Projects/aoc/2023/7/input.txt";
	isValidString = i: isString i && i != "";
	inputLines = filter isValidString (builtins.split "\n" input);
	hands = map (i: filter isValidString (builtins.split " " i)) inputLines;
	sortedHands = sort (a: b: cmpHand (elemAt a 0) (elemAt b 0)) hands;
	handWinnings = mapWithIndex (a: i: (i + 1) * (toInt (elemAt a 1))) sortedHands;
	result = foldl' (x: y: x + y) 0 handWinnings;
}
