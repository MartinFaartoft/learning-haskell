module Main where

import Control.Monad (forever)
import Data.Char (toLower)
import Data.Maybe (isJust)
import Data.List (intersperse)
import System.Exit (exitSuccess)
import System.Random (randomRIO)
import System.IO

type WordList = [String]

allWords :: IO WordList
allWords = do
  dict <- readFile "data/dict.txt"
  return $ lines dict

minWordLength :: Int
minWordLength = 3

maxWordLength :: Int
maxWordLength = 9

gameWords :: IO WordList
gameWords = do
  aw <- allWords
  let gameLength w = let l = length (w :: String) in l > minWordLength && l < maxWordLength
  return (filter gameLength aw)
  --where gameLength w = let l = length (w :: String) in l > minWordLength && l < maxWordLength  

randomWord :: WordList -> IO String
randomWord wl = do
  randomIndex <- randomRIO (0, length wl - 1)
  return $ wl !! randomIndex

randomWord' :: IO String
randomWord' = gameWords >>= randomWord

data Puzzle = Puzzle String [Maybe Char] [Char]

instance Show Puzzle where 
  show (Puzzle _ discovered guessed) =
    (intersperse ' ' $ fmap renderPuzzleChar discovered)
    ++ " Guessed so far: " ++ guessed

freshPuzzle :: String -> Puzzle
freshPuzzle word = Puzzle word (maskWord word) []
  where maskWord w = map (\x -> Nothing) w

charInWord :: Puzzle -> Char -> Bool
charInWord (Puzzle word _ _) guess = elem guess word

alreadyGuessed :: Puzzle -> Char -> Bool
alreadyGuessed (Puzzle _ _ guessed) guess = elem guess guessed

renderPuzzleChar :: Maybe Char -> Char
renderPuzzleChar Nothing = '_'
renderPuzzleChar (Just c) = c

fillInCharacter :: Puzzle -> Char -> Puzzle
fillInCharacter (Puzzle word filledInSoFar s) c =
  Puzzle word newFilledInSoFar (c : s)
  where 
    zipper guessed wordChar guessChar = 
      if wordChar == guessed 
        then Just wordChar 
        else guessChar 
    newFilledInSoFar =
      zipWith (zipper c) word filledInSoFar

handleGuess :: Puzzle -> Char -> IO Puzzle
handleGuess puzzle guess = do
  putStrLn $ "Your guess was: " ++ [guess]
  case (charInWord puzzle guess, alreadyGuessed puzzle guess) of
    (_, True) -> do
      putStrLn "You already guess that character"
      return puzzle
    (True, _) -> do
      putStrLn "Good guess!"
      return (fillInCharacter puzzle guess)
    (False, _) -> do
      putStrLn "Bad guess! :("
      return (fillInCharacter puzzle guess)

gameOver :: Puzzle -> IO ()
gameOver (Puzzle word _ guessed) =
  if (length guessed) > 7 then
    do 
      putStrLn $ "GAME OVER, word was: " ++ word
      exitSuccess
  else return ()

gameWin :: Puzzle -> IO ()
gameWin (Puzzle _ filledInSoFar _) =
  if all isJust filledInSoFar then
    do putStrLn "WINNER"
       exitSuccess
  else return ()

runGame :: Puzzle -> IO ()
runGame puzzle = forever $ do
  gameOver puzzle
  gameWin puzzle
  putStrLn $ show puzzle
  putStr "Guess a letter: "
  guess <- getLine
  case guess of
    [c] -> handleGuess puzzle c >>= runGame
    _ -> putStrLn "single char plz"

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  putStrLn "let's play"
  word <- randomWord'
  let puzzle = freshPuzzle (fmap toLower word)
  runGame puzzle
