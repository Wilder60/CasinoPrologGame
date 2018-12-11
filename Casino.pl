:- use_module(library(pio)).
/**********************************************************************************************************************/
% All the functions that deal with the deck and all the helper functions
/**********************************************************************************************************************/
createDeck(NewDeck) :-
    NewDeck = [
        [s,a], [s,2], [s,3], [s,4], [s,5], [s,6], [s,7], [s,8], [s,9], [s,x], [s,j], [s,q], [s,k],
        [d,a], [d,2], [d,3], [d,4], [d,5], [d,6], [d,7], [d,8], [d,9], [d,x], [d,j], [d,q], [d,k],
        [c,a], [c,2], [c,3], [c,4], [c,5], [c,6], [c,7], [c,8], [c,9], [c,x], [c,j], [c,q], [c,k],
        [h,a], [h,2], [h,3], [h,4], [h,5], [h,6], [h,7], [h,8], [h,9], [h,x], [h,j], [h,q], [h,k]
        ].

shuffleDeck(Deck, ShuffledDeck) :-
    random_permutation(Deck, NewShuffledDeck),
    ShuffledDeck = NewShuffledDeck.

resetDeck(ReturnDeck) :-
    createDeck(NewDeck),
    shuffleDeck(NewDeck, ReturnDeck).

dealCards(0, [FirstCard|RestofDeck], [], ReturnDeck) :-
    ReturnDeck = [FirstCard|RestofDeck].

dealCards(Iteration, [FirstCard|RestofDeck], List, ReturnDeck) :-
    NewIteration is Iteration - 1,
    dealCards(NewIteration, RestofDeck, NewList, NewReturnDeck),
    List = [FirstCard | NewList],
    ReturnDeck = NewReturnDeck.

startingCards(Deck, HumanHand, ComputerHand, Board, ReturnDeck) :-
    dealCards(4, Deck, HumanHand, PartialDeck),
    dealCards(4, PartialDeck, ComputerHand, NewPartialDeck),
    dealCards(4, NewPartialDeck, Board, NewNewPartialDeck),
    ReturnDeck = NewNewPartialDeck.

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
makeMove(Tournament, 1) :-
    nth0(5, Tournament, HumanHand),
    displayNumbericalList(0, HumanHand),
    write("\nEnter the number of the card you want to BUILD with:"),
    read(CardName),
    isVaildHandCard(HumanHand, CardName, Tournament).

makeMove(Tournament, 2) :-
    extractBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile),
    displayNumbericalList(0, HumanHand),
    write("\nEnter the number of the card you want to CAPTURE with:"),
    read(Input),
    isVaildSelection(HumanHand, Input),
    nth0(Input, HumanHand, Card),
    captureCards(Tournament, Board, HumanHand, HumanPile, Card, NewBoard, NewHumanHand, NewHumanPile),
    insertBoardHumanHandAndPile(Tournament, NewBoard, NewHumanHand, NewHumanPile, UpdatedTournament),
    getDeckAndHands(UpdatedTournament, Deck, TournamentHumanHand, TournamentComputerHand),
    playRound(UpdatedTournament, computer, "You captured a card", Deck, TournamentHumanHand, TournamentComputerHand).

makeMove(Tournament, 3) :-
    extractBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile),
    displayNumbericalList(0, HumanHand),
    write("\nEnter the number of the card you want to TRAIL with:"),
    read(Input),
    isVaildSelection(HumanHand, Input),
    nth0(Input, HumanHand, Card),
    trailCard(Board, HumanHand, Card, NewBoard, NewHumanHand),
    insertBoardHumanHandAndPile(Tournament, NewBoard, NewHumanHand, HumanPile, UpdatedTournament),
    getDeckAndHands(UpdatedTournament, Deck, TournamentHumanHand, TournamentComputerHand),
    playRound(UpdatedTournament, computer, "You trailed a card", Deck, TournamentHumanHand, TournamentComputerHand).

makeMove(Tournament, 4) :-
    write("You've played Casino long enough, you don't need help\n"),
    makeMove(Tournament, 5).

makeMove(Tournament, _) :-
    write("Enter:\n\t1. BUILD\t2. CAPTURE\t3. TRAIL\t4. HELP\nInput:"),
    read(X),
    makeMove(Tournament, X).

isVaildHandCard([], _, Tournament) :-
    write("\nError: Invaild hand card!\n"),
    makeMove(Tournament, 5).

isVaildHandCard([InputCard|_], InputCard, _).

isVaildHandCard( [_|RestofHand], InputCard, Tournament) :-
    isVaildHandCard(RestofHand, InputCard, Tournament).

extractBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile) :-
    nth0(7, Tournament, Board),
    nth0(6, Tournament, HumanPile),
    nth0(5, Tournament, HumanHand).

insertBoardHumanHandAndPile(Tournament, Board, HumanHand, HumanPile, UpdatedTournament) :-
    insertIntoTournament(7, Tournament, Board, NewTournament),
    insertIntoTournament(6, NewTournament, HumanPile, NewNewTournament),
    insertIntoTournament(5, NewNewTournament, HumanHand, UpdatedTournament).

isVaildSelection(HumanHand, Input) :-
    length(HumanHand, MAX),
    Input > -1,
    Input < MAX.

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
    
sumTotal([], Total) :-
    Total = 0.

sumTotal([FirstCard | RestofList], Total) :-
    sumTotal(RestofList, NewTotal),
    getValue(FirstCard, Value),
    Total = Value + NewTotal.

getValue([_, a], Value) :-
    Value = 1.
getValue([_, 2], Value) :-
    Value = 2.
getValue([_, 3], Value) :-
    Value = 3.
getValue([_, 4], Value) :-
    Value = 4.
getValue([_, 5], Value) :-
    Value = 5.
getValue([_, 6], Value) :-
    Value = 6.
getValue([_, 7], Value) :-
    Value = 7.
getValue([_, 8], Value) :-
    Value = 8.
getValue([_, 9], Value) :-
    Value = 9.
getValue([_, x], Value) :-
    Value = 10.
getValue([_, j], Value) :-
    Value = 11.
getValue([_, q], Value) :-
    Value = 12.
getValue([_, k], Value) :-
    Value = 13.

%***********************************************************************************************************************

makeComputerMove(Tournament) :-
    extractBoardComputerHandAndPile(Tournament, Board, ComputerHand, ComputerPile),
    nth0(0, ComputerHand, FirstCard),
    trailCard(Board, ComputerHand, FirstCard, NewBoard, NewComputerHand),
    insertBoardComputerHandAndPile(Tournament, NewBoard, NewComputerHand, ComputerPile, UpdatedTournament),
    getDeckAndHands(UpdatedTournament, Deck, HumanHand, UpdatedComputerHand),
    playRound(UpdatedTournament, human, "The Computer trailed", Deck, HumanHand, UpdatedComputerHand).


extractBoardComputerHandAndPile(Tournament, Board, ComputerHand, ComputerPile) :-
    nth0(7, Tournament, Board),
    nth0(2, Tournament, ComputerHand),
    nth0(3, Tournament, ComputerPile).
    
insertBoardComputerHandAndPile(Tournament, Board, ComputerHand, ComputerPile, UpdatedTournament) :-
    insertIntoTournament(7, Tournament, Board, NewTournament),
    insertIntoTournament(3, NewTournament, ComputerPile, NewNewTournament),
    insertIntoTournament(2, NewNewTournament, ComputerHand, FinalUpdatedTournament),
    UpdatedTournament = FinalUpdatedTournament.

insertIntoTournament(0, [_|RestofTheTournament], ListToBeAdded, NewTournament) :-
    NewTournament = [ListToBeAdded|RestofTheTournament].

insertIntoTournament(Iteration, [FirstItem|RestofTheTournament], ListToBeAdded, NewTournament) :-
    NewIteration is Iteration - 1,
    insertIntoTournament(NewIteration, RestofTheTournament, ListToBeAdded, NewNewTournament),
    NewTournament = [FirstItem | NewNewTournament].

removeCardFromList([Card | RestofList], Card, NewList) :-
    NewList = RestofList.
removeCardFromList([FirstCard | RestofList], Card , NewList) :-
    removeCardFromList(RestofList, Card, UpdatedList),
    NewList = [FirstCard | UpdatedList].

removeListFromList(ListToRemoveFrom, [], UpdatedList) :-
    UpdatedList = ListToRemoveFrom.

removeListFromList(ListToRemoveFrom, [FirstElem | RestofList], UpdatedList) :-
    removeCardFromList(ListToRemoveFrom, FirstElem, NewList),
    removeListFromList(NewList, RestofList, UpdatedList).


%***********************************************************************************************************************
captureCards(Tournament, Board, HuamnHand, HumanPile, Card, NewBoard, NewHumanHand, NewHumanPile) :-
    displayNumbericalList(0, Board),
    write("\nEnter the number of the card to capture, or 100 to exit"),
    read(Input),
    getCards(Board, CaptureCards, Input),
    sumTotal(CaptureCards, Total),
    getValue(Card, CardValue),
    Check is mod(Total, CardValue),
    isVaildCapture(Tournament, Check),
    append(HumanPile, CaptureCards, UpdatedPile),
    append(UpdatedPile, [Card], NewHumanPile),
    removeCardFromList(HuamnHand, Card, NewHumanHand),
    removeListFromList(Board, CaptureCards, NewBoard).

isVaildCapture(_, 0).

isVaildCapture(Tournament, _) :-
    write("Error, Invalid Capture set!"),
    makeMove(Tournament, 5).


trailCard(Board, Hand, Card, NewBoard, NewHand) :-
    append(Board, [Card], UpdatedBoard),
    removeCardFromList(Hand, Card, UpdatedHand),
    NewBoard = UpdatedBoard,
    NewHand = UpdatedHand.
    
%***********************************************************************************************************************
% All the functions that deal with the Round
%***********************************************************************************************************************
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

addBoardToPile(Tournament, Board, human, UpdatedTournament):-
    nth0(6, Tournament, HumanPile),
    append(HumanPile, Board, UpdatedPile),
    insertIntoTournament(6, Tournament, UpdatedPile, UpdatedTournament).

addBoardToPile(Tournament, Board, omputer, UpdatedTournament):-
    nth0(3, Tournament, HumanPile),
    append(HumanPile, Board, UpdatedPile),
    insertIntoTournament(3, Tournament, UpdatedPile, UpdatedTournament).

getDeckAndHands(Tournament, Deck, HumanHand, ComputerHand) :-
    nth0(9, Tournament, Deck),
    nth0(2, Tournament, ComputerHand),
    nth0(5, Tournament, HumanHand).

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

displayList([]).
displayList([FirstElement | RestofList]) :-
    write(FirstElement),
    write(" "),
    displayList(RestofList).

displayNumbericalList(_, []).

displayNumbericalList(Count, [FirstElem|RestofList]) :-
    format("~d. ", Count),
    write(FirstElem),
    write("\t"),
    IncCount is Count + 1,
    displayNumbericalList(IncCount, RestofList).

%_________________________________TOURNAMENT____________________________________________________________________________
createTournament(Tournament) :-
    resetDeck(Deck),
    startingCards(Deck, HumanHand, ComputerHand, Board, ReturnDeck),
    Tournament = [1, 0, ComputerHand, [], 0, HumanHand, [], Board, "Computer", ReturnDeck, "Computer"].

playTournament(Tournament) :-
    nth0(10, Tournament, NextPlayer),
    getDeckAndHands(Tournament, Deck, HumanHand, ComputerHand),
    playRound(Tournament, NextPlayer, "", Deck, HumanHand, ComputerHand).

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

saveGame(_, y) :-
    halt(0).

saveGame(_, _).

endScreen(Tournament) :-
    write('\33\[2J'),
    nth0(1, Tournament, ComputerScore),
    nth0(3, Tournament, ComputerPile),
    %calculatepoints(ComputerPile, ComputerScore, UpdatedComputerScore),
    format("\n\nComputer Score:\t ~d", ComputerScore),
    write("\n\nComputerPile:\n"),
    displayList(ComputerPile), 
    write("\n\n\n"),
    nth0(4, Tournament, HumanScore),
    nth0(6, Tournament, HumanPile),
    %calculatepoints(HumanPile, HumanScore, UpdatedHumanScore),
    displayList(HumanPile),
    write("\n\nHumanPile:\n"),
    format("Human Score:\t ~d", HumanScore),

    write("\nPress any key to continue"),
    read(_),
    resetTournament(Tournament, UpdatedTournament),
    playTournament(UpdatedTournament).

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

%_________________________________MAIN FUNCTION THAT IS CALLED__________________________________________________________
loadGame() :-
    write("Enter the name of the file you want to load"),
    read(File),
    open(File, read, Stream),
    read(Stream, Tournament),
    playTournament(Tournament).
    
createGame() :-
    createTournament(Tournament),
    write("Enter 'h' for Heads and 't' for tails\t"),
    read(CoinFlip),
    random_between(0, 2, R),
    coinFlip(R, CoinFlip, Tournament, NewTournament),
    playTournament(NewTournament).

loadOrCreate(l) :-
    loadGame().

loadOrCreate(c) :-
    createGame().

loadOrCreate(_) :-
    write("Error enter l or c\t"),
    read(Input),
    loadOrCreate(Input).

main() :-
    write('\33\[2J'),
    write("Would you like to create a new game or load a save game (l/c)\t"),
    read(Input),
    loadOrCreate(Input).