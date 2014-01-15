\version "2.14.2"

#(set! paper-alist (cons '("two line" . (cons (* 15 in) (* 3 in))) paper-alist))

\paper {
  #(set-paper-size "two line")
}

rhMusic = \relative c' {
  c8 r e r c' 
}

lhMusic = \relative c {
  r8 d r c r 
}

rhChars = \lyricmode {
  c e c
}

lhChars = \lyricmode {
  d c
}


\score {
  \new PianoStaff <<
  
    \new Staff = "RH"  <<
      \key c \major
      \clef "treble"
      \new Voice = "rhVoice" <<	
        \rhMusic 
      >>
    >>
    \new Lyrics \lyricsto "rhVoice" {
      \rhChars
    }


    \new Staff = "LH" <<
      \key c \major
      \clef "bass"
      \new Voice = "lhVoice" <<
        \lhMusic
      >>
    >>
    \new Lyrics \with { alignAboveContext = "LH" } {
      \lyricsto "lhVoice" {
        \lhChars
      }
    } 
  >>
}
