require 'set'
require 'byebug'

class Game

    def initialize(players)
        @players=players
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
        @fragment=self.reset_fragment
        @losses=Hash.new(0)
    end

    def reset_fragment
        "abcdefghijklmnopqrstuvwxyz".split("").sample
    end

    def end?
        @losses.each do |k,v|
            if v==5
                puts "Player #{k} is dead"
                return true
            end
        end
        false
    end

    def run
        until end?
            self.play_round
        end
    end

    def play_round
        while self.take_turn(self.current_player)
            self.next_player!
        end
        @fragment=self.reset_fragment
    end

    def current_player
        @players[0]
    end

    def previous_player
        @players[-1]
    end

    def next_player!
        @players<<@players.shift
    end

    def score_board
        word="GHOST"
        @losses.each do |player,loss|
            if loss>0
                puts "#{player}: "+ word[0...loss]
            end
        end
    end

    def take_turn(player)
        puts "This is #{player}'s turn"
        puts "The fragment is #{@fragment}"
        puts "Give a letter to add to the fragment:"
        letter=gets.chomp
        if !self.valid_play?(letter)
            debugger
            puts "#{player} losses a life"
            @losses[player]+=1
            puts self.score_board
            return false
        else
            @fragment+=letter
            return true
        end
    end

    def valid_play?(letter)
        alphas="abcdefghijklmnopqrstuvwxyz".split("")
        new_frag=@fragment+letter.downcase
        if !alphas.include?(letter.downcase)
            puts "invalid move, give one letter only"
            return false
        elsif @dictionary.include?(new_frag)
            puts "you hit a valid word: #{new_frag}"
            return false
        end
        @dictionary.each do |ele|
            if ele.start_with?(new_frag)
                return true
            end
        end
        return false
    end

end