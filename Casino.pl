%************************************************************
%* Name: Andrew Wild                                        *
%* Project:  Casino Prolog Project 4                        *
%* Class: 36602                                             *
%* Date:  12/14/2018                                        *
%************************************************************
/**********************************************************************************************************************/
% All the functions that deal with the deck and all the helper functions
/**********************************************************************************************************************/
%Function Name: createDeck
%Purpose: creates a new list containing all the cards in the deck
%Parameters: NewDeck
%Local Variables: None
%Algorithm:
			%1) set NewDeck to the list of all cards
%Assistance Received: none
createDeck(NewDeck) :-
    NewDeck = [
        [s,a], [s,2], [s,3], [s,4], [s,5], [s,6], [s,7], [s,8], [s,9], [s,x], [s,j], [s,q], [s,k],
        [d,a], [d,2], [d,3], [d,4], [d,5], [d,6], [d,7], [d,8], [d,9], [d,x], [d,j], [d,q], [d,k],
        [c,a], [c,2], [c,3], [c,4], [c,5], [c,6], [c,7], [c,8], [c,9], [c,x], [c,j], [c,q], [c,k],
        [h,a], [h,2], [h,3], [h,4], [h,5], [h,6], [h,7], [h,8], [h,9], [h,x], [h,j], [h,q], [h,k]
        ].

%Function Name: shuffleDeck
%Purpose: to take in a list of cards and randomly shuffle it
%Parameters: Deck
%            ShuffledDeck
%Local Variables: None
%Algorithm:
%           1) Call random_permutation on Deck
%           2) assign ShuffledDeck to NewShuffledDeck
%Assistance Received: Stack Overflow
shuffleDeck(Deck, ShuffledDeck) :-
    random_permutation(Deck, NewShuffledDeck),
    ShuffledDeck = NewShuffledDeck.

%Function Name: resetDeck
%Purpose: to create a deck and shuffle it
%Parameters: ReturnDeck
%Local Variables: NewDeck
%Algorithm:
%           1) Call createDeck 
%           2) Call shuffleDeck
%Assistance Received: none
resetDeck(ReturnDeck) :-
    createDeck(NewDeck),
    shuffleDeck(NewDeck, ReturnDeck).

%Function Name: dealCards
%Purpose: To remove the top n cards from the top of the deck and return a list and the deck with 4 less cards
%Parameters: Iteration, [FirstCard|RestofDeck], List, ReturnDeck
%Local Variables: NewIteration, NewListm NewReturnDeck
%Algorithm:
%           1) while Iteration is not zero
%           2) recurse
%           3) Assign List = [FirstCard| NewList]
%           4) Set ReturnDeck = NewReturnDeck
%Assistance Received: none
dealCards(0, [FirstCard|RestofDeck], [], ReturnDeck) :-
    ReturnDeck = [FirstCard|RestofDeck].

dealCards(Iteration, [FirstCard|RestofDeck], List, ReturnDeck) :-
    NewIteration is Iteration - 1,
    dealCards(NewIteration, RestofDeck, NewList, NewReturnDeck),
    List = [FirstCard | NewList],
    ReturnDeck = NewReturnDeck.

%Function Name: startingCards
%Purpose: to give the hands and table for cards at the start of the game
%Parameters: Deck, HumanHand, ComputerHand, Board, ReturnDeck
%Local Variables: PartialDeck, NewPartialDeck, NewNewPartialDeck
%Algorithm:
%           1) Create a list with 4 cards and assign it to the HumanHand
%           2) Create a list with 4 cards and assign it to the ComputerHand
%           3) Create a list with 4 cards and assign it to the Board
%           4) assign NewNewPartialDeck to ReturnDeck
%Assistance Received: none
startingCards(Deck, HumanHand, ComputerHand, Board, ReturnDeck) :-
    dealCards(4, Deck, HumanHand, PartialDeck),
    dealCards(4, PartialDeck, ComputerHand, NewPartialDeck),
    dealCards(4, NewPartialDeck, Board, NewNewPartialDeck),
    ReturnDeck = NewNewPartialDeck.

%Function Name: refreshHands
%Purpose: add 4 more cards to the deck and insert them into the tournament
%Parameters: Tournament, Deck, UpdatedTournament, UpdatedDeck, HumanHand, ComputerHand
%Local Variables: 
%Algorithm:
%           1) call dealCards and assign it to NewHumanHand 
%           2) call dealCards and assign it to NewComputerHand
%           3) insert the NewHumanHand, NewComputerHand, and DealtDeck  into the Tournament list
%           4) assign UpdateTournament = CompletedTournament,     UpdatedDeck = DealtDeck, HumanHand = NewHumanHand,
%              ComputerHand = NewComputerHand
%Assistance Received: none
refreshHands(Tournament, Deck, UpdatedTournament, UpdatedDeck, HumanHand, ComputerHand) :-
    dealCards(4, Deck, NewHumanHand, PartialDeck),
    dealCards(4, PartialDeck, NewComputerHand, DealtDeck),
    insertIntoTournament(2, Tournament, NewComputerHand, TournamentWithCH),
    insertIntoTournament(5, TournamentWithCH, NewHumanHand, TournamentWithBH),
    insertIntoTournament(9, TournamentWithBH, DealtDeck, CompletedTournament),
    UpdatedTournament = CompletedTournament,
    UpdatedDeck = DealtDeck,
    HumanHand = NewHumanHand,
    ComputerHand = NewComputerHand.

/**********************************************************************************************************************/
% All the functions that deal with the players
/**********************************************************************************************************************/
%Function Name: makeMove
%Purpose: The command for the huamn to make a build UNFINISHED
%Parameters: Tournament, 1
%Local Variables: HumanHand, CardName
%Algorithm:
%           1) Gets the HumanHand List
%           2) Call displayNumbericalList with HumanHand
%           3) Prompt the user and read in the input
%Assistance Received: none
makeMove(Tournament, 1) :-
    nth0(5, Tournament, HumanHand),
    displayNumbericalList(0, HumanHand),
    write("\nEnter the number of the card you want to BUILD with:"),
    read(CardName).

%Function Name: makeMove
%Purpose: The command for the huamn to capture a card or set of cards
%Parameters: Tournament, 2
%Local Variables: Board, HumanHand, HumanPile, Input, Card, NewBoard, NewHumanHand, NewHumanPile, UpdatedTournament,
%                   FinalUpdatedTournament, TournamentHumanHand, TournamentComputerHand, NewFinalUpdatedTournament
%Algorithm:
%           1) Get the Board, HumanHand, HumanPile as lists
%           2) call displayNumbericalList with HumanHand
%           3) read in the input from the user and check if its valid
%           4) call nth0 with input on HumanHand to get the card selected
%           5) call captureCards function
%           6) insert the new board Hand and pile into the tournament and set last capture to human
%           7) get the Deck and Hands of the players
%           8) set the next player to computer
%           9) call playRound
%Assistance Received: none
makeMove(Tournament, 2) :-
    extractBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile),
    displayNumbericalList(0, HumanHand),
    write("\nEnter the number of the card you want to CAPTURE with:"),
    read(Input),
    isVaildSelection(HumanHand, Input),
    nth0(Input, HumanHand, Card),
    captureCards(Tournament, Board, HumanHand, HumanPile, Card, NewBoard, NewHumanHand, NewHumanPile),
    insertBoardHumanHandAndPile(Tournament, NewBoard, NewHumanHand, NewHumanPile, UpdatedTournament),
    insertIntoTournament(8, UpdatedTournament, human, FinalUpdatedTournament),
    getDeckAndHands(FinalUpdatedTournament, Deck, TournamentHumanHand, TournamentComputerHand),
    insertIntoTournament(10, FinalUpdatedTournament, computer, NewFinalUpdatedTournament),
    playRound(NewFinalUpdatedTournament, computer, "You captured a card", Deck, TournamentHumanHand, TournamentComputerHand).

%Function Name: makeMove
%Purpose: The command for the huamn to trail a card
%Parameters: Tournament, 3
%Local Variables: Board, HumanHand, HumanPile, Input, Card, NewBoard, NewHumanHand, UpdatedTournament, TournamentHumanHand
%                   TournamentComputerHand, NewFinalUpdatedTournament
%Algorithm:
%           1) extract the Board, HumanHand, HumanPile from the Tournament
%           2) display the hand and prompt the user for input
%           3) read in the Input
%           4) check to see if the input is valid
%           5) get the nth0 card from the hand
%           6) check to see if you could trail the card
%           7) add the card to the board
%           8) insert the new board Hand and pile into the tournament
%           9) get the Deck and Hands of the players
%           10) set the next player to computer
%           11) call playRound
%Assistance Received: none
makeMove(Tournament, 3) :-
    extractBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile),
    displayNumbericalList(0, HumanHand),
    write("\nEnter the number of the card you want to TRAIL with:"),
    read(Input),
    isVaildSelection(HumanHand, Input),
    nth0(Input, HumanHand, Card),
    isVaildTrail(Tournament, Board, Card),
    trailCard(Board, HumanHand, Card, NewBoard, NewHumanHand),
    insertBoardHumanHandAndPile(Tournament, NewBoard, NewHumanHand, HumanPile, UpdatedTournament),
    getDeckAndHands(UpdatedTournament, Deck, TournamentHumanHand, TournamentComputerHand),
    insertIntoTournament(10, UpdatedTournament, computer, NewFinalUpdatedTournament),
    playRound(NewFinalUpdatedTournament, computer, "You trailed a card", Deck, TournamentHumanHand, TournamentComputerHand).

%Function Name: makeMove
%Purpose: The command to ask for help
%Parameters: Tournament, 5
%Local Variables: Tournament
%Algorithm:
%           1) Prints a string for "help"
%           2) calls makeMove(Tournament, 5)
%Assistance Received: none
makeMove(Tournament, 4) :-
    write("You've played Casino long enough, you don't need help\n"),
    makeMove(Tournament, 5).

%Function Name: makeMove
%Purpose: The base case for the makeMove class
%Parameters: Tournament, _
%Local Variables: Tournamnet X
%Algorithm:
%           1) Display the move options
%           2) Prompt the user for input
%           3) call makeMove with the input
%Assistance Received: none
makeMove(Tournament, _) :-
    write("Enter:\n\t1. BUILD\t2. CAPTURE\t3. TRAIL\t4. HELP\nInput:"),
    read(X),
    makeMove(Tournament, X).

%Function Name: extractBoardHumanHandAndPile
%Purpose: get the Board, HumanHand, and HumanPile from the Tournament List
%Parameters: Tournament, Board, HumanHand, HumanPile
%Local Variables: none
%Algorithm:
%           1) call nth0 to get the Board list
%           2) call nth0 to get the HumanPile
%           3) call nth0 to get the HumanHand
%Assistance Received: none
extractBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile) :-
    nth0(7, Tournament, Board),
    nth0(6, Tournament, HumanPile),
    nth0(5, Tournament, HumanHand).

%Function Name: insertBoardHumanHandAndPile
%Purpose: to insert the board, Humanhand, and humanPile into the Tournament
%Parameters: Tournament, Board, HumanHand, HumanPile, UpdatedTournament
%Local Variables: NewTournament, NewNewTournament
%Algorithm:
%           1) Insert the Board into the Tournament
%           2) Insert the HumanHand into the Tournament
%           3) Insert the HumanPile into the Tournament
%Assistance Received: none
insertBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile, UpdatedTournament) :-
    insertIntoTournament(7, Tournament, Board, NewTournament),
    insertIntoTournament(6, NewTournament, HumanPile, NewNewTournament),
    insertIntoTournament(5, NewNewTournament, HumanHand, UpdatedTournament).

%Function Name: isVaildSelection
%Purpose: To create is the number Input exists in length of the list
%Parameters: HumanHand, Input
%Local Variables: Max
%Algorithm:
%           1) Get the length of the list and store in MAX
%           2) check if Input > -1
%           3) check if Input < MAX
%Assistance Received: none
isVaildSelection(HumanHand, Input) :-
    length(HumanHand, MAX),
    Input > -1,
    Input < MAX.

%Function Name: getCards
%Purpose: To get all cards that the human wants to capture
%Parameters: Board, CapturedCards, Input
%Local Variables: Card, UpdatedBoard, NewInput, NewCaptures
%Algorithm:
%           1) check to see if Input is valid
%           2) set Card to the card at Input
%           3) remove the card from the board
%           4) display the Updated the Board
%           5) prompt for a new input
%           6) recurse
%           7) set CapturedCards to Card plus the NewCaptures
%Assistance Received: none
getCards([], CapturedCards, _) :-
    CapturedCards = [].

getCards(_, CapturedCards, 100) :-
    CapturedCards = [].

getCards(Board, CapturedCards, Input):-
    isVaildSelection(Board, Input),
    nth0(Input, Board, Card),
    removeCardFromList(Board, Card, UpdatedBoard),
    displayNumbericalList(0, UpdatedBoard),
    writeln("\nEnter card name or 100 to stop: \t"),
    read(NewInput),
    getCards(UpdatedBoard, NewCaptures, NewInput),
    CapturedCards = [Card|NewCaptures].

%Function Name: sumTotal
%Purpose: To sum the total of call the cards in the list
%Parameters: [FirstCard | ResofList], Total
%Local Variables: NewTotal, Value
%Algorithm:
%           1) recurse until list is empty
%           2) then get the value of the FirstCard
%           3) add Value to the NewTotal
%Assistance Received: none
sumTotal([], Total) :-
    Total = 0.

sumTotal([FirstCard | RestofList], Total) :-
    sumTotal(RestofList, NewTotal),
    getValue(FirstCard, Value),
    Total is Value + NewTotal.

getValue([_, a], 1).
getValue([_, 2], 2).
getValue([_, 3], 3).
getValue([_, 4], 4).
getValue([_, 5], 5).
getValue([_, 6], 6).
getValue([_, 7], 7).
getValue([_, 8], 8).
getValue([_, 9], 9).
getValue([_, x], 10).
getValue([_, j], 11).
getValue([_, q], 12).
getValue([_, k], 13).

%Function Name: makeComputerMove
%Purpose: The most that the computer makes on its turn
%Parameters: Tournamnet
%Local Variables: Board, ComputerHand, ComputerPile, FirstCard, NewBoard, NewComputerHand, UpdatedTournament, Deck,
%                   HumanHand, UpdatedComputerHand, FinalUpdatedTournament
%Algorithm:
%           1) extract the Board, ComputerHand, and ComputerPile
%           2) get the first card from the hand
%           3) call trail card
%           4) insert the new board, computerhand and computerpile into the tournament
%           5) get the deck, humanhand, and computerhand from the tournament
%           6) insert the nextplayer into the tournament
%           7) call playRound clause
%Assistance Received: none
makeComputerMove(Tournament) :-
    extractBoardComputerHandAndPile(Tournament, Board, ComputerHand, ComputerPile),
    nth0(0, ComputerHand, FirstCard),
    trailCard(Board, ComputerHand, FirstCard, NewBoard, NewComputerHand),
    insertBoardComputerHandAndPile(Tournament, NewBoard, NewComputerHand, ComputerPile, UpdatedTournament),
    getDeckAndHands(UpdatedTournament, Deck, HumanHand, UpdatedComputerHand),
    insertIntoTournament(10, UpdatedTournament, human, FinalUpdatedTournament),
    playRound(FinalUpdatedTournament, human, "The Computer trailed", Deck, HumanHand, UpdatedComputerHand).

%Function Name: extractBoardComputerHandAndPile
%Purpose: To extract the Board, ComputerHand, and ComputerPile from the Tournament
%Parameters: Tournament, Board, ComputerHand, ComputerPile
%Local Variables: none
%Algorithm:
%           1) call nth0 to get the Board list
%           2) call nth0 to get the ComputerHand list
%           3) call nth0 to get the ComputerPile list
%Assistance Received: none
extractBoardComputerHandAndPile(Tournament, Board, ComputerHand, ComputerPile) :-
    nth0(7, Tournament, Board),
    nth0(2, Tournament, ComputerHand),
    nth0(3, Tournament, ComputerPile).
    
%Function Name: makeMove
%Purpose: The command for the huamn to make a build
%Parameters: Tournament, 1
%Local Variables: HumanHand, CardName
%Algorithm:
%           1) Gets the HumanHand List
%           2) Call displayNumbericalList with HumanHand
%           3) Prompt the user and read in the input
%Assistance Received: none
insertBoardComputerHandAndPile(Tournament, Board, ComputerHand, ComputerPile, UpdatedTournament) :-
    insertIntoTournament(7, Tournament, Board, NewTournament),
    insertIntoTournament(3, NewTournament, ComputerPile, NewNewTournament),
    insertIntoTournament(2, NewNewTournament, ComputerHand, FinalUpdatedTournament),
    UpdatedTournament = FinalUpdatedTournament.

%Function Name: insertIntoTournament
%Purpose: To insert a atom or list into the Tournament at a given location
%Parameters: Iteration, [FirstItem|RestofTheTournament], ListToBeAdded, NewTournament
%Local Variables: NewIteration, NewNewTournament
%Algorithm:
%           1) recurse until Iteration is zero
%           2) then construct the list with ListToBeAdded and RestofTheTournament
%           3) add the FirstItem to the NewNewTournament
%Assistance Received: none
insertIntoTournament(0, [_|RestofTheTournament], ListToBeAdded, NewTournament) :-
    NewTournament = [ListToBeAdded|RestofTheTournament].

insertIntoTournament(Iteration, [FirstItem|RestofTheTournament], ListToBeAdded, NewTournament) :-
    NewIteration is Iteration - 1,
    insertIntoTournament(NewIteration, RestofTheTournament, ListToBeAdded, NewNewTournament),
    NewTournament = [FirstItem | NewNewTournament].

%Function Name: removeCardFromList
%Purpose: To remove a card from a list of cards
%Parameters: [Card | RestofList], Card, NewList
%Local Variables: UpdatedList
%Algorithm:
%           1) recurse until the Card is the First element of the list
%           2) set the NewList to the RestofList
%           3) assign NewList = [FirstCard|UpdatedList]
%Assistance Received: none
removeCardFromList([Card | RestofList], Card, NewList) :-
    NewList = RestofList.
removeCardFromList([FirstCard | RestofList], Card , NewList) :-
    removeCardFromList(RestofList, Card, UpdatedList),
    NewList = [FirstCard | UpdatedList].

%Function Name: removeListFromList
%Purpose: To remove a list of cards from a list of Cards
%Parameters: ListToRemoveFrom, [FirstElem | RestofList], UpdatedList
%Local Variables: none
%Algorithm:
%           1) call removeCardFromList with FirstElem
%           2) recurse
%Assistance Received: none
removeListFromList(ListToRemoveFrom, [], UpdatedList) :-
    UpdatedList = ListToRemoveFrom.

removeListFromList(ListToRemoveFrom, [FirstElem | RestofList], UpdatedList) :-
    removeCardFromList(ListToRemoveFrom, FirstElem, NewList),
    removeListFromList(NewList, RestofList, UpdatedList).

%Function Name: captureCards
%Purpose: To prompt the user to capture cards
%Parameters: Tournament, Board, HuamnHand, HumanPile, Card, NewBoard, NewHumanHand, NewHumanPile
%Local Variables: Input, CaptureCards, Total, CardValue, Check, NewHumanHandNewBoard, NewHumanPile, UpdatedPile
%Algorithm:
%           1) display the calls on the board
%           2) prompt the user to select a card
%           3) get all the cards they want to capture wilth getCards
%           4) check that the cards a vaildvalues
%           5) sum the cards and get the value of the caputre card
%           6) modulus the two values and check it is zero
%           7) remove the captureCards from the board
%           8) remove the captureCard from the hand
%           9) check there are no cards with the same value on the table
%           10) append the caputreCards and the caputreCard to the HumanPile
%Assistance Received: none
captureCards(Tournament, Board, HuamnHand, HumanPile, Card, NewBoard, NewHumanHand, NewHumanPile) :-
    displayNumbericalList(0, Board),
    write("\nEnter the number of the card to capture, or 100 to exit"),
    read(Input),
    getCards(Board, CaptureCards, Input),
    checkCardsForValidValues(Tournament, CaptureCards, Card),
    sumTotal(CaptureCards, Total),
    getValue(Card, CardValue),
    Check is mod(Total, CardValue),
    isVaildCapture(Tournament, Check),
    removeListFromList(Board, CaptureCards, NewBoard),
    removeCardFromList(HuamnHand, Card, NewHumanHand),
    noSameCards(Tournament, NewBoard, Card),
    append(HumanPile, CaptureCards, UpdatedPile),
    append(UpdatedPile, [Card], NewHumanPile).

%Function Name: isVaildCapture
%Purpose: To see if the total of the capture set mod the Capture Card value is zero
%Parameters: Tournament, Value
%Local Variables: none
%Algorithm:
%           1) if Value != 0
%           2) write Error Message
%           3) call makeMove
%Assistance Received: none
isVaildCapture(_, 0).

isVaildCapture(Tournament, _) :-
    write("Error, Invalid Capture set!"),
    makeMove(Tournament, 5).

%Function Name: checkCardsForValidValues
%Purpose: To check if the captures are valued cards to capture
%Parameters: Tournament, [FirstCard | RestofDeck], Card
%Local Variables: none
%Algorithm:
%           1) call biggerValue with FirstCard and Card
%           2) recurse
%Assistance Received: none
checkCardsForValidValues(_, [],_).

checkCardsForValidValues(Tournament, [FirstCard | RestofDeck], Card) :-
    biggerValue(Tournament, FirstCard, Card),
    checkCardsForValidValues(Tournament, RestofDeck, Card).

%Function Name: biggerValue
%Purpose: To check to see if a card in the capture pile is bigger then the target cards
%Parameters: Tournament, [_,Value1], [_,Value2]
%Local Variables: none
%Algorithm:
%           1) if Value1 is bigger then value2
%           2) write Error Message
%           4) call makeMove
%           3) else return
%Assistance Received: none
biggerValue(Tournament, [_, Value1], [_, Value2]) :-
    Value1 > Value2,
    write("\nInvalid card in capture pile!\n\n"),
    makeMove(Tournament, 5).

biggerValue(_, [_, Value1], [_, Value2]) :-
    Value1 =< Value2.

%Function Name: noSameCards
%Purpose: To check if the board has no same cards
%Parameters: Tournament, [FirstCard | RestofBoard], Card
%Local Variables: none
%Algorithm:
%           1) check to see if the cards have the same values
%           2) recurse
%Assistance Received: none
noSameCards(_, [], _).

noSameCards(Tournament, [FirstCard | RestofBoard], Card) :-
    sameCardValue(Tournament, FirstCard, Card),
    noSameCards(Tournament, RestofBoard, Card).

%Function Name: sameCardValue
%Purpose: To check to see if there are cards on table that you can capture
%Parameters: Tournament, [_,Value1], [_,Value1]
%Local Variables: none
%Algorithm:
%           1) if the cards have the same value
%           2) print error message
%           3) call makeMove
%Assistance Received: none
sameCardValue(Tournament, [_, Value1], [_, Value1]) :-
    write("\n\nThere are cards on the table you need to capture\n\n"),
    makeMove(Tournament, 5).

sameCardValue(_, [_, _], [_, _] ).

%Function Name: trailCard
%Purpose: To trail the card from the hand to the board
%Parameters: Board, Hand, Card, NewBoard, NewHand
%Local Variables: UpdatedBoard, UpdatedHand
%Algorithm:
%           1) append Card to the board
%           2) remove Card from the hand
%Assistance Received: none
trailCard(Board, Hand, Card, NewBoard, NewHand) :-
    append(Board, [Card], UpdatedBoard),
    removeCardFromList(Hand, Card, UpdatedHand),
    NewBoard = UpdatedBoard,
    NewHand = UpdatedHand.

%Function Name: isVaildTrail
%Purpose: To check to see if you can trail the selected card
%Parameters: Tournament, [FirstCard|RestofDeck], Card
%Local Variables: none
%Algorithm:
%           1) check to see if the cards have same value
%           2) recurse
%Assistance Received: none
isVaildTrail(_, [], _).

isVaildTrail(Tournament, [FirstCard|RestofDeck], Card):-
    sameValue(Tournament, FirstCard, Card),
    isVaildTrail(Tournament, RestofDeck, Card).

%Function Name: sameValue
%Purpose: checks to see if the two cards have the same value
%Parameters: Tournament, [_,Value], [_,Value]
%Local Variables: none
%Algorithm:
%           1) if the card has the same value
%           2) print an Error message
%           3) call makeMove
%Assistance Received: none
sameValue(Tournament, [_, Value], [_, Value]) :-
    write("Error you can not trail with matching loose cards on the table\n"),
    makeMove(Tournament, 5).

sameValue(_, _, _).


%***********************************************************************************************************************
% All the functions that deal with the Round
%***********************************************************************************************************************
%Function Name: playRound
%Purpose: To decide if the round is over, or make the approiapte players move
%Parameters: Tournament, NextPlayer, Message, Deck, HumanHand, ComputerHand
%Local Variables: LastCapture, Board, SaveCommand
%Algorithm:
%           1) if the Deck and the Hands are empty call addBoardToPile and end the round
%           2) if the Deck has cards but the hand are empty call refreshHands then recurse
%           3) update the screen
%           4) prompt the user if they want to save
%           5) call saveGame function
%           6) call playRound function
%Assistance Received: none
playRound(Tournament, _, _, [], [], []) :-
    nth0(8, Tournament, LastCapture),
    nth0(7, Tournament, Board),
    addBoardToPile(Tournament, Board, LastCapture, UpdatedTournament),
    endScreen(UpdatedTournament).

playRound(Tournament, NextPlayer, Message, Deck, [], []) :-
    refreshHands(Tournament, Deck, UpdatedTournament, UpdatedDeck, HumanHand, ComputerHand),
    playRound(UpdatedTournament, NextPlayer, Message, UpdatedDeck, HumanHand, ComputerHand).

playRound(Tournament, human, Message, _, _, _) :-
    updateDisplayScreen(Tournament, Message),
    write("Would you like to Save (y/n)"),
    read(SaveCommand),
    saveGame(Tournament, SaveCommand),
    makeMove(Tournament, 5).

playRound(Tournament, computer, Message, _, _, _) :-
    updateDisplayScreen(Tournament, Message),
    write("Would you like to Save (y/n)"),
    read(SaveCommand),
    saveGame(Tournament, SaveCommand),
    makeComputerMove(Tournament).

%Function Name: addBoardToPile
%Purpose: add all the cards from the board to the LastCapturers pile
%Parameters: Tournament, Board, LastCapture, UpdatedTourament
%Local Variables: UpdatedPile
%Algorithm:
%           1) if the LastCapture is human extract the HumanPile else extract the ComputerPile
%           2) append the Board to the pile
%           3) insert the Pile into the Tournamnet
%Assistance Received: none
addBoardToPile(Tournament, Board, human, UpdatedTournament):-
    nth0(6, Tournament, HumanPile),
    append(HumanPile, Board, UpdatedPile),
    insertIntoTournament(6, Tournament, UpdatedPile, UpdatedTournament).

addBoardToPile(Tournament, Board, computer, UpdatedTournament):-
    nth0(3, Tournament, HumanPile),
    append(HumanPile, Board, UpdatedPile),
    insertIntoTournament(3, Tournament, UpdatedPile, UpdatedTournament).

%Function Name: getDeckAndHands
%Purpose: To get the Deck and both players hands
%Parameters: Tournament, Deck, HumanHand, ComputerHand
%Local Variables: none
%Algorithm:
%           1) extract the Deck from the Tournament
%           2) extract the ComputerHand from the Tournament
%           3) extract the HumanHand from the Tournament
%Assistance Received: none
getDeckAndHands(Tournament, Deck, HumanHand, ComputerHand) :-
    nth0(9, Tournament, Deck),
    nth0(2, Tournament, ComputerHand),
    nth0(5, Tournament, HumanHand).

%Function Name: updateDisplayScreen
%Purpose: To display the current game state to the screen
%Parameters: Tournament Message
%Local Variables: RoundCount, ComputerScore, ComputerPile, ComputerHand, Board, HumanHand, HumanPile, HumanScore, Deck
%Algorithm:
%           1) extract each element from the list
%           2) if it a atom write to the screen
%           3) if it is a list call displayList
%           4) diplay the message
%Assistance Received: none
%this is ugly and I think I can make it better
updateDisplayScreen(Tournament, Message) :-    
    write('\33\[2J'),
    nth0(0, Tournament, RoundCount),
    format("Round: ~d", RoundCount),
    write("\n\n"), 
    nth0(1, Tournament, ComputerScore),
    format("Score: ~d", ComputerScore),
    write("\nPile: "),
    nth0(3, Tournament, ComputerPile),
    displayList(ComputerPile),
    write("\nHand: "),
    nth0(2, Tournament, ComputerHand),
    displayList(ComputerHand),
    write("\n\nTable: "),
    nth0(7, Tournament, Board),
    displayList(Board),
    write("\n\n"),
    write("Hand: "),
    nth0(5, Tournament, HumanHand),
    displayList(HumanHand),
    write("\nPile: "),
    nth0(6, Tournament, HumanPile),
    displayList(HumanPile),
    nth0(4, Tournament, HumanScore),
    format("\nScore: ~d", HumanScore),
    write("\n\nDeck:"),
    nth0(9, Tournament, Deck),
    displayList(Deck),
    write("\n"),
    format("\n ~s \n", Message).

%Function Name: displayList
%Purpose: to display each element in a list
%Parameters: [FirstElement | ResofList]
%Local Variables: none
%Algorithm:
%           1) print the FirstElement + " "
%           2) recurse
%Assistance Received: none
displayList([]).
displayList([FirstElement | RestofList]) :-
    write(FirstElement),
    write(" "),
    displayList(RestofList).

%Function Name: displayNumbericalList
%Purpose: to display the list passed in with a number before it
%Parameters: Count, [FirstElem|RestofList]
%Local Variables: IncCount
%Algorithm:
%           1) print Count. and FirstElem
%           2) increase Count by 1
%           3) recurse
%Assistance Received: none
displayNumbericalList(_, []).
displayNumbericalList(Count, [FirstElem|RestofList]) :-
    format("~d. ", Count),
    write(FirstElem),
    write("\t"),
    IncCount is Count + 1,
    displayNumbericalList(IncCount, RestofList).

%_________________________________TOURNAMENT____________________________________________________________________________
%Function Name: createTournament
%Purpose: to create a new Tournament
%Parameters: Tournament
%Local Variables: Deck, HumanHand, ComputerHand, Board, ReturnDeck
%Algorithm:
%           1) call resetDeck to get a new deck
%           2) call startingCards to get a lists with 4 cards fro the HumanHand, ComputerHand and the Board
%           3) consturct a new Tournament with the lists and new Deck
%Assistance Received: none
createTournament(Tournament) :-
    resetDeck(Deck),
    startingCards(Deck, HumanHand, ComputerHand, Board, ReturnDeck),
    Tournament = [1, 0, ComputerHand, [], 0, HumanHand, [], Board, "Computer", ReturnDeck, "Computer"].

%Function Name: playTournament
%Purpose: To start the playRound clause
%Parameters: Tournament
%Local Variables: NextPlayer, Deck, HumanHand, ComputerHand
%Algorithm:
%           1) get the Nexplayer, deck, HumanHand, and ComputerHand
%           2) Call playRound
%Assistance Received: none
playTournament(Tournament) :-
    nth0(10, Tournament, NextPlayer),
    getDeckAndHands(Tournament, Deck, HumanHand, ComputerHand),
    playRound(Tournament, NextPlayer, "", Deck, HumanHand, ComputerHand).

%Function Name: resetTournamenet
%Purpose: 
%Parameters: Tournament, UpdatedTournament
%Local Variables: Round, ComputerScore, HumanScore, Nextplayer, NewTournament0 - 4
%Algorithm:
%           1) extract the Round, ComputerScore, HumanScore and NextPlayer from the Tournament
%           2) create a new Tournament
%           3) increase the Round by one
%           4) insert the NewRound, ComputerScore, HumanScore, and nextPlayer into the new Tournament
%Assistance Received: none
resetTournament(Tournament, UpdatedTournament) :-
    nth0(0, Tournament, Round),
    nth0(1, Tournament, ComputerScore),
    nth0(4, Tournament, HumanScore),
    nth0(8, Tournament, NextPlayer),
    createTournament(NewTournament),
    NextRound is Round + 1,
    insertIntoTournament(0, NewTournament, NextRound, NewTournament0),
    insertIntoTournament(1, NewTournament0, ComputerScore, NewTournament1),
    insertIntoTournament(4, NewTournament1, HumanScore, NewTournament2),
    insertIntoTournament(8, NewTournament2, NextPlayer, NewTournament3),
    insertIntoTournament(10, NewTournament3, NextPlayer, UpdatedTournament).

%Function Name: saveGame
%Purpose: To save the Tournament list to a file
%Parameters: Tournamnet, Input
%Local Variables: Str
%Algorithm:
%           1) if Input is y
%           2) create a file named SaveGame and open a write stream Str
%           3) write the Tournament to the file
%           4) write a . to the end
%           5) close the stream and halt
%Assistance Received: none
saveGame(Tournament, y) :-
    open('SaveGamed.txt', append, Str),
    write(Str, Tournament),
    write(Str, '.'),
    close(Str),
    halt(0).

saveGame(_, _).

%Function Name: endScreen
%Purpose: To print the end screen and check to see who won
%Parameters: Tournament
%Local Variables: ComputerScore, ComputerPile, HumanScore, HumanPile, UpdatedComputerScore, UpdatedHumanScore,
%                   UpdatedTournament, FinalTournamnetUpdate
%Algorithm:
%           1) get the ComputerScore, ComputerPile, HumanScore, HumanPile
%           2) calculate the points earned during the round and add it to the Scores
%           3) display the Computer score and pile
%           4) display the Human pile and score
%           5) prompt the user to enter to continue
%           6) check to see if someone won the gane
%           7) reset the tournament
%           8) insert the Scores into the Tournament
%           9) call playTournmanet
%Assistance Received: none
endScreen(Tournament) :-
    write('\33\[2J'),
    nth0(1, Tournament, ComputerScore),
    nth0(3, Tournament, ComputerPile),
    nth0(4, Tournament, HumanScore),
    nth0(6, Tournament, HumanPile),
    calculatepoints(ComputerPile, ComputerScore, UpdatedComputerScore, HumanPile, HumanScore, UpdatedHumanScore),
    format("\n\nComputer Score:\t ~d", UpdatedComputerScore),
    write("\n\nComputerPile:\n"),
    displayList(ComputerPile), 
    write("\n\n\n"),
    displayList(HumanPile),
    write("\n\nHumanPile:\n"),
    format("Human Score:\t ~d", UpdatedHumanScore),

    write("\nPress any key to continue"),
    read(_),
    winGame(UpdatedHumanScore, UpdatedComputerScore),
    resetTournament(Tournament, UpdatedTournament),
    insertScores(UpdatedTournament, UpdatedHumanScore, UpdatedComputerScore, FinalTournametUpdate),
    playTournament(FinalTournametUpdate).

%Function Name: calculatepoints
%Purpose: To calculate the points for each player
%Parameters: ComputerPile, ComputerScore, UpdatedComputerScore, HumanPile, HumanScore, UpdatedHumanScore
%Local Variables: CPilelen, HPileLen, TempCScore, TempHScore, TempCValue, TempHValue, ComputerClubs, HumanClubs
%Algorithm:
%           1) get the length of ComputerPile and HumanPile
%           2) call biggerPile
%           3) call totalScore for the Computer and Human
%           4) call totalClubs for the Computer and Human
%           5) call moreClubs to check to see who had more clubs
%Assistance Received: none
calculatepoints(ComputerPile, ComputerScore, UpdatedComputerScore, HumanPile, HumanScore, UpdatedHumanScore) :-
    length(ComputerPile, CPilelen),
    length(HumanPile, HPileLen),
    biggerPile(CPilelen, HPileLen, ComputerScore, HumanScore, TempCScore, TempHScore),
    totalScore(ComputerPile, TempCScore, TempCValue),
    totalScore(HumanPile, TempHScore, TempHValue),
    totalClubs(ComputerPile, 0, ComputerClubs),
    totalClubs(HumanPile, 0, HumanClubs),
    moreClubs(ComputerClubs, HumanClubs, TempCValue, TempHValue, UpdatedComputerScore, UpdatedHumanScore).

%Function Name: bigger
%Purpose: Check to see if one pile is bigger and give points to the proper player
%Parameters: CPilelen, HPileLen, ComputerScore, HumanScore, TempCScore, TempHScore
%Local Variables: none
%Algorithm:
%           1) if the length of Computer pile is bigger give computer 3 points
%           2) if the length of HumanPile is bigger give human 3 points
%           3) no one gets points
%Assistance Received: none
biggerPile(CPilelen, HPileLen, ComputerScore, HumanScore, TempCScore, TempHScore) :-
    CPilelen > HPileLen,
    TempCScore is ComputerScore + 3,
    TempHScore is HumanScore.

biggerPile(CPilelen, HPileLen, ComputerScore, HumanScore, TempCScore, TempHScore) :-
    CPilelen < HPileLen,
    TempHScore is HumanScore + 3,
    TempCScore is ComputerScore.

biggerPile(CPilelen, HPileLen, ComputerScore, HumanScore, TempCScore, TempHScore) :-
    CPilelen =:= HPileLen,
    TempCScore is ComputerScore,
    TempHScore is HumanScore.

%Function Name: totalScore
%Purpose: To iterate through a list
%Parameters: [FirstCard|RestofPile], TempScore, Value
%Local Variables: 
%Algorithm:
%           1) Gets the HumanHand List
%           2) Call displayNumbericalList with HumanHand
%           3) Prompt the user and read in the input
%Assistance Received: none
totalScore([], TempScore, Value) :-
    Value = TempScore.

totalScore([FirstCard | RestofPile], TempScore, Value) :-
    getPoints(FirstCard, Points),
    NewTempScore is TempScore + Points,
    totalScore(RestofPile, NewTempScore, Value).

getPoints([d,x], 2).
getPoints([s,2], 1).
getPoints([_,a], 1).
getPoints([_,_], 0).

%Function Name: totalClubs
%Purpose: To find a number of clubs in a list
%Parameters: [FirstCard|RestofPile], TempClubs, Total
%Local Variables: Value, NewTempClubs
%Algorithm:
%           1) call getClubs with FirstCard
%           2) add the value returned to NewTempClubs
%           3) recurse until list is empty
%Assistance Received: none
totalClubs([], TempClubs, Total) :-
    Total = TempClubs.

totalClubs([FirstCard | RestofPile], TempClubs, Total) :-
    getClubs(FirstCard, Value),
    NewTempClubs is TempClubs + Value,
    totalClubs(RestofPile, NewTempClubs, Total).

getClubs([c,_], 1).
getClubs([_,_], 0).

%Function Name: moreClubs
%Purpose: increase the score of the person who has the most clubs
%Parameters: CClubs, HClubs, TempCScore, TempHScore, UpdatedComputerScore, UpdatedHumanScore
%Local Variables: none
%Algorithm:
%           1) if the computer has more clubs increase the score by one
%           2) if the human has more clubs increase the score by one
%           3) else no one gets any points
%Assistance Received: none
moreClubs(CClubs, HClubs, TempCScore, TempHScore, UpdatedComputerScore, UpdatedHumanScore) :-
    CClubs > HClubs,
    UpdatedComputerScore is TempCScore + 1,
    UpdatedHumanScore = TempHScore.

moreClubs(CClubs, HClubs, TempCScore, TempHScore, UpdatedComputerScore, UpdatedHumanScore) :-
    CClubs < HClubs,
    UpdatedHumanScore is TempHScore + 1,
    UpdatedComputerScore = TempCScore.

moreClubs(CClubs, HClubs, TempCScore, TempHScore, UpdatedComputerScore, UpdatedHumanScore) :-
    CClubs =:= HClubs,
    UpdatedComputerScore = TempCScore,
    UpdatedHumanScore = TempHScore.

%Function Name: insertScores
%Purpose: To insert the new scores into the Tournament object
%Parameters: UpdatedTournament, UpdatedHumanScore, UpdatedComputerScore, FinalTournametUpdate
%Local Variables: NewTournament
%Algorithm:
%           1) Insert the HumanScore into the Tournament
%           2) Insert the ComputerScore into the Tournament
%Assistance Received: none
insertScores(UpdatedTournament, UpdatedHumanScore, UpdatedComputerScore, FinalTournametUpdate) :-
    insertIntoTournament(4, UpdatedTournament, UpdatedHumanScore, NewTournament),
    insertIntoTournament(1, NewTournament, UpdatedComputerScore, FinalTournametUpdate).

%Function Name: winGame
%Purpose: To determine who wins the game
%Parameters: HumanScore, ComputerScore
%Local Variables: none
%Algorithm:
%           1) if the humanScore is greater then 21 and the computerscore the human wins
%           2) if the computerScore is greater then 21 and the humanscore the computer wins
%           3) if the computerScore and the HumanScore are the same and greater then 21 its a tie
%Assistance Received: none
winGame(HumanScore, ComputerScore) :-
    ComputerScore > 20,
    ComputerScore > HumanScore,
    write("\n\nThe Computer has won!"),
    halt(0).


winGame(HumanScore, ComputerScore) :-
    HumanScore > 20,
    ComputerScore < HumanScore,
    write("The Human has won!"),
    halt(0).

winGame(HumanScore, ComputerScore) :-
    HumanScore > 20,
    ComputerScore =:= HumanScore,
    write("The Game has ended in a time!"),
    halt(0).

winGame(_,_).

%Function Name: coinFlip
%Purpose: To determine if you won or loss the coinFlip
%Parameters: RandomNumber, UserInput, Tournament, NewNewTournament
%Local Variables: NewTournament
%Algorithm:
%           1) if RandomNumber is 1 and UserInpuut is h OR if RandomNumber is 0 and UserInput is t
%           2) insert human into nextplayer and last capture
%           3) else
%           4) insert computer into nextplayer and last capture
%Assistance Received: none
coinFlip(1, h, Tournament, NewNewTournament):-
    write("\nYou won the coin toss\n"),
    insertIntoTournament(8, Tournament, human, NewTournament),
    insertIntoTournament(10, NewTournament, human, NewNewTournament).

coinFlip(0, t, Tournament, NewNewTournament):-
    write("\nYou won the coin toss\n"),
    insertIntoTournament(8, Tournament, human, NewTournament),
    insertIntoTournament(10, NewTournament, human, NewNewTournament).

coinFlip(_, _, Tournament, NewNewTournament):-
    write("\nThe Computer won the coin toss\n"),
    insertIntoTournament(8, Tournament, computer, NewTournament),
    insertIntoTournament(10, NewTournament, computer, NewNewTournament).

%*********************************MAIN FUNCTION THAT IS CALLED**********************************************************
%Function Name: loadGame
%Purpose: To load a tournament from a file and start playing
%Parameters: none
%Local Variables: File, Stream, Tournament
%Algorithm:
%           1) prompt the user for a file name
%           2) open the file in a read stream
%           3) read the information in the file into Tournament
%           4) close the stream
%           5) call playTournament with Tournament
%Assistance Received: none
loadGame() :-
    write("Enter the name of the file you want to load"),
    read(File),
    open(File, read, Stream),
    read(Stream, Tournament),
    close(Stream),
    playTournament(Tournament).
    
%Function Name: createGame
%Purpose: To create a new Tournament and start playing
%Parameters: none
%Local Variables: Tournament, CoinFlip, R, NewTournament
%Algorithm:
%           1) create a new Tournament
%           2) prompt the user for h or t
%           3) geneterate a number between 0 and 1
%           4) call coinFlip
%           5) call playTournament with the Tournament returned from coinFlip
%Assistance Received: none
createGame() :-
    createTournament(Tournament),
    write("Enter 'h' for Heads and 't' for tails\t"),
    read(CoinFlip),
    random_between(0, 2, R),
    coinFlip(R, CoinFlip, Tournament, NewTournament),
    playTournament(NewTournament).

%Function Name: loadOrCreate
%Purpose: To figure if the user wants to load or create a game
%Parameters: Input
%Local Variables: Input
%Algorithm:
%           1) if Input is l call loadGame
%           2) if Input is c call createGame
%           3) if its neither prompt for input again and recurse
%Assistance Received: none
loadOrCreate(l) :-
    loadGame().

loadOrCreate(c) :-
    createGame().

loadOrCreate(_) :-
    write("Error enter l or c\t"),
    read(Input),
    loadOrCreate(Input).

%Function Name: main
%Purpose: The start of the game
%Parameters: none
%Local Variables: Input
%Algorithm:
%           1) Clear the Screen
%           2) Prompt the user if they want to create a new game or load a savedGame
%           3) Get the input
%           4) call loadOrCreate with the input
%Assistance Received: none
main() :-
    write('\33\[2J'),
    write("Would you like to create a new game or load a save game (l/c)\t"),
    read(Input),
    loadOrCreate(Input).