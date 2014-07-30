%% This is file `nia.cls', a simple extension of `article.cls', to be used
%% for the preparation of NIA Technical Reports. 
%%
%% Version 1.d
%%
%% By Cesar A. Munoz (munoz@nianet.org)
%% 
%% Modifications:
%% 
%% Jul 2005 (Version 1d)
%%  Modified NIA address
%%
%% Jul 2004 (Version 1c)
%%  Added \nia to print National Institute of Aerospace (NIA), <NIA address>
%%  Added \niaemail{<name>} to print <name>@nianet.org
%%  Added \niaweb{<name>} to print http://research.nianet.org/~<name>
%%
%% Sep 2003 (Version 1b)
%%   \draftbanner : Prints a DRAFT banner across the pages in postscript file
%%   \doubleline  : Double space.
%%
%% Jun 2003 (Version 1a)
%%   \acknowledegments --> \acknowledgments
%%
%% Jan 2003 (Version 1)
%%   First version.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nia}[2003/09/10 NIA (Technical Reports) Style class]
\LoadClass[12pt]{article}

\bibliographystyle{plain} 

\newcommand{\draftbanner}{\special{!userdict begin /bop-hook{gsave 200 30 translate
65 rotate /Times-Roman findfont 216 scalefont setfont
0 0 moveto 0.9 setgray (DRAFT) show grestore}def end}}

\newcommand{\doubleline}{\renewcommand\baselinestretch{1.5}}

\newcommand{\nia}{National Institute of Aerospace (NIA), 100 Exploration Way, Hampton VA, 23666}

\DeclareOption{draft}{\doubleline\draftbanner}
\ProcessOptions

\RequirePackage{url}
\RequirePackage{ifthen}

\setlength{\textwidth}{6.5in}
\setlength{\textheight}{9in}
\setlength{\topmargin}{-0.5in}
\setlength{\oddsidemargin}{0in}
\pagenumbering{arabic}

%+++  Definitions  +++

\renewcommand{\section}{%
      \@startsection
          {section}{1}{\z@}%
          {-1.5ex plus -1ex minus -.2ex}%
          {1ex plus .2ex}
         {\normalsize\bf\MakeUppercase}%
}
\renewcommand{\subsection}{%
      \@startsection
         {subsection}{2}{\z@}
         {-1.5ex plus -1ex minus -.2ex}%
         {1ex plus .2ex}{\normalsize\bf}%
}
\newcounter{thanks}
\renewcommand{\thethanks}{\fnsymbol{thanks}}
\newcommand{\email}{\url}
\newcommand{\web}{\url}
\newcommand{\niaemail}[1]{\email{#1@nianet.org}}
\newcommand{\niaweb}[1]{\web{http://research.nianet.org/~#1}}
\newcommand{\address}{\thanks}

\renewenvironment{abstract}{\begin{quote}\small\centerline{\bf ABSTRACT}}{\end{quote}}
\renewcommand{\title}[2][0]{\begin{center}{\large\MakeUppercase{\bf #2}}\ifthenelse{\equal{#1}{0}}{}{\thanks{#1}}\end{center}}
\newcommand{\subtitle}[1]{\vspace*{-9mm}\begin{center}{\small\MakeUppercase{\bf #1}}\end{center}}
\renewcommand{\author}[1]{\begin{center}#1\end{center}\bigskip}
\renewcommand{\thanks}[1]{\stepcounter{thanks}\renewcommand\thefootnote\thethanks\footnote{#1}\setcounter{footnote}{0}}

\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: {\it #2}}%
  \ifdim \wd\@tempboxa >\hsize
    #1: {\it #2}\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

\newcommand{\acknowledgments}{\subsection*{ACKNOWLEDGMENTS}}

\renewcommand{\refname}{REFERENCES}



