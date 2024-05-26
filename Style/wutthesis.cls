%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Huangrui Mo <huangrui.mo@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{wutthesis}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{wutthesis}[2014/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifwut@print \wut@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \wut@printtrue%
}
%-
%-> Language
%-
\newif\ifwut@plain \wut@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \wut@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifwut@versioninfo \wut@versioninfofalse
\DeclareOption{draftversion}{%
    \wut@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{wutthesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\wutifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\wutifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\wutlntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/wutthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifwut@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.5em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\wut@value@ch@confidential{}
\newcommand{\confidential}[1]{\def\wut@value@ch@confidential{#1}}
\def\wut@value@ch@orderid{}
\newcommand{\orderid}[1]{\def\wut@value@ch@orderid{#1}}
\def\wut@value@ch@classid{}
\newcommand{\classid}[1]{\def\wut@value@ch@classid{#1}}
\def\wut@value@ch@udc{}
\newcommand{\udc}[1]{\def\wut@value@ch@udc{#1}}
\def\wut@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\wut@value@ch@schoollogo{\wutifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\wut@value@ch@title{}
\def\wut@value@ch@titlemark{}
\renewcommand{\title}[2][\wut@value@ch@title]{%
    \def\wut@value@ch@title{#2}
    %\def\wut@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\wut@value@ch@titlemark{#1}}
\def\wut@value@ch@author{}
\renewcommand{\author}[1]{\def\wut@value@ch@author{#1}}
\def\wut@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\wut@value@ch@advisor{#1}}
\def\wut@value@ch@advisors{}
\newcommand{\advisors}[1]{\long\def\wut@value@ch@advisors{#1}}
\def\wut@value@ch@degree{}
\newcommand{\degree}[1]{\def\wut@value@ch@degree{#1}}
\def\wut@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\wut@value@ch@degreetype{#1}}
\def\wut@value@ch@subject{}
\newcommand{\subject}[1]{\def\wut@value@ch@subject{#1}}
\def\wut@value@ch@major{}
\newcommand{\major}[1]{\def\wut@value@ch@major{#1}}
\def\wut@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\wut@value@ch@institute{#1}}
\def\wut@value@ch@school{}
\newcommand{\school}[1]{\def\wut@value@ch@school{#1}}
\def\wut@value@ch@orginization{}
\newcommand{\orginization}[1]{\def\wut@value@ch@orginization{#1}}
\def\wut@value@ch@completedate{}
\newcommand{\completedate}[1]{\def\wut@value@ch@completedate{#1}}
\def\wut@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\wut@value@ch@submitdate{#1}}
\def\wut@value@ch@studydatefrom{}
\newcommand{\studydatefrom}[1]{\def\wut@value@ch@studydatefrom{#1}}
\def\wut@value@ch@studydateto{}
\newcommand{\studydateto}[1]{\def\wut@value@ch@studydateto{#1}}
\def\wut@value@ch@date{}
\renewcommand{\date}[1]{\def\wut@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\wut@value@en@title{}
\def\wut@value@en@titlemark{}
\newcommand{\TITLE}[2][\wut@value@en@title]{%
    \def\wut@value@en@title{#2}
    %\def\wut@value@en@titlemark{\MakeUppercase{#1}}}
    \def\wut@value@en@titlemark{#1}}
\def\wut@value@en@author{}
\newcommand{\AUTHOR}[1]{\def\wut@value@en@author{#1}}
\def\wut@value@en@advisor{}
\newcommand{\ADVISOR}[1]{\def\wut@value@en@advisor{#1}}
\def\wut@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\wut@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\wut@value@en@degreetype{}
\newcommand{\DEGREETYPE}[1]{\def\wut@value@en@degreetype{#1}}
\def\wut@value@en@thesistype{}
\newcommand{\THESISTYPE}[1]{\def\wut@value@en@thesistype{#1}}
\def\wut@value@en@major{}
\newcommand{\MAJOR}[1]{\def\wut@value@en@major{#1}}
\def\wut@value@en@institute{}
\newcommand{\INSTITUTE}[1]{\def\wut@value@en@institute{#1}}
\def\wut@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\wut@value@en@school{#1}}
\def\wut@value@en@date{}
\newcommand{\DATE}[1]{\def\wut@value@en@date{#1}}
%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \wutifstreq{\wut@value@en@degree}{Bachelor}{%
        \def\wut@label@ch@thesis{\wut@label@ch@thesis@bac}%
        \def\wut@label@ch@author{\wut@label@ch@author@bac}%
        \def\wut@label@ch@major{\wut@label@ch@major@bac}%
        \def\wut@label@ch@institute{\wut@label@ch@institute@bac}%
        \def\wut@value@en@thesistype{\wut@value@en@thesistype@bac}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \wutifstreq{\wut@value@en@degree}{Master}{%
        \def\wut@label@ch@thesis{\wut@label@ch@thesis@mas}%
        \def\wut@label@ch@author{\wut@label@ch@author@mas}%
        \def\wut@label@ch@major{\wut@label@ch@major@mas}%
        \def\wut@label@ch@institute{\wut@label@ch@institute@mas}%
        \def\wut@value@en@thesistype{\wut@value@en@thesistype@mas}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \wutifstreq{\wut@value@en@degree}{Doctor}{%
        \def\wut@label@ch@thesis{\wut@label@ch@thesis@doc}%
        \def\wut@label@ch@author{\wut@label@ch@author@doc}%
        \def\wut@label@ch@major{\wut@label@ch@major@doc}%
        \def\wut@label@ch@institute{\wut@label@ch@institute@doc}%
        \def\wut@value@en@thesistype{\wut@value@en@thesistype@doc}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \wutifstreq{\wut@value@en@degree}{Postdoctor}{%
        \def\wut@label@ch@thesis{\wut@label@ch@thesis@pdc}%
        \def\wut@label@ch@author{\wut@label@ch@author@pdc}%
        \def\wut@label@ch@major{\wut@label@ch@major@pdc}%
        \def\wut@label@ch@institute{\wut@label@ch@institute@pdc}%
        \def\wut@value@en@thesistype{\wut@value@en@thesistype@pdc}%
        \def\maketitle{\maketitle@pdc}
        \def\MAKETITLE{\MAKETITLE@pdc}
    }{%
        \ClassWarning{wutthesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}}%
}
%-
%-> Define Chinese style
%-
\newcommand{\maketitle@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \hfill{} \wutifstrbk{\wut@value@ch@confidential}{}{\wut@label@ch@confidential \ulenhance{\ulextend[50pt]{\hspace*{-\ulhshift}\zihao{5}\wut@value@ch@confidential}}}

        \vspace*{\stretch{4}}

        {\wut@value@ch@schoollogo}

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\wut@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\wut@value@ch@title}}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{lc}
            \wut@label@ch@author & \ulenhance[1.2pt]{\ulextend{\wut@value@ch@author}}\\
            \wut@label@ch@advisor & \wutlntotab[1.2pt]{\wut@value@ch@advisor}\\
            \wut@label@ch@degree & \ulenhance[1.2pt]{\ulextend{\wut@value@ch@degreetype\wut@value@ch@degree}}\\
            \wut@label@ch@major & \ulenhance[1.2pt]{\ulextend{\wut@value@ch@major}}\\
            \wut@label@ch@institute & \wutlntotab[1.2pt]{\wut@value@ch@institute}\\
        \end{tabular}

        \vspace*{\stretch{4}}

        {\wut@value@ch@date}

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifwut@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifwut@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifwut@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
\newcommand{\maketitle@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}

        \vspace*{30pt}

        \linespread{2.0}
        \zihao{4}

        \makebox[3.0em][s]{\wut@label@ch@classid} \ulenhance{\ulextend[6em]{\zihao{5}\wut@value@ch@classid}} \hfill{} \wut@label@ch@confidential \ulenhance{\ulextend[6em]{\zihao{5}\wut@value@ch@confidential}}

        \makebox[3.0em][s]{\wut@label@ch@udc} \ulenhance{\ulextend[6em]{\zihao{5}\wut@value@ch@udc}} \hfill{} \wut@label@ch@orderid \ulenhance{\ulextend[6em]{\zihao{5}\wut@value@ch@orderid}}

        \vspace*{\stretch{6}}

        {\ziju{1.5}\wut@value@ch@schoollogo}

        \vspace*{\stretch{1}}

        {\zihao{-2}\bfseries\sffamily{\ziju{0.5}\wut@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3} \ulenhance[1.5pt]{\wut@value@ch@title}}

        \vspace*{\stretch{2.5}}

        \wut@value@ch@author

        \vspace*{\stretch{2.5}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}c}
            \wut@label@ch@completedate & \ulenhance{\ulextend[200pt]{\wut@value@ch@completedate}}\\
            \wut@label@ch@submitdate & \ulenhance{\ulextend[200pt]{\wut@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{2}}

        \wut@value@ch@institute

        \wut@value@ch@date

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
    \ifwut@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%-
%-> Define English style
%-
\newcommand{\MAKETITLE@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \vspace*{50pt}

        {\zihao{-3}\bfseries \ulenhance[1.5pt]{\wut@value@en@title}}

        \vspace*{\stretch{3}}

        {\wut@label@en@statement}

        {By}

        {\wut@value@en@author}

        {\wut@value@en@advisor}

        \vspace*{\stretch{3}}

        {\wut@value@en@institute}

        \vspace*{\stretch{1}}

        {\wut@value@en@date}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
\newcommand{\MAKETITLE@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{2.0}
        \zihao{4}

        \vspace*{50pt}

        {\zihao{3} \wut@value@ch@title}

        \vspace*{\stretch{3}}

        {\zihao{-3} \wut@value@en@title}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}l}
            \makebox[11em][s]{\wut@label@ch@author} & \wut@value@ch@author\\
            \makebox[11em][s]{\wut@label@ch@subject} & \wut@value@ch@subject\\
            \makebox[11em][s]{\wut@label@ch@major} & \wut@value@ch@major\\
        \end{tabular}

        \vspace*{\stretch{3}}

        \wut@label@ch@studydatefrom \quad \wut@value@ch@studydatefrom

        \wut@label@ch@studydateto \quad \wut@value@ch@studydateto

        \vspace*{\stretch{3}}

        \wut@value@ch@orginization

        \wut@value@ch@date

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.6}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \wut@label@ch@declare@creativity}
        \end{center}

        {\wut@value@ch@declare@creativity}

        \vspace*{3ex}

        {\hfill{} {\wut@label@ch@declare@author \hspace*{14em}}}

        {\hfill{} {\wut@label@ch@declare@date \hspace*{14em}}}

        \vspace*{6ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \wut@label@ch@declare@rights}
        \end{center}

        {\wut@value@ch@declare@rights}

        {\wut@value@ch@declare@rule}

        \vspace*{3ex}

        {\hfill{} {\wut@label@ch@declare@author \hspace*{10em} \wut@label@ch@declare@advisor \hspace*{9em}}}

        {\hfill{} {\wut@label@ch@declare@date \hspace*{10em} \wut@label@ch@declare@date \hspace*{9em}}}

        \vspace*{3ex}
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \wut@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \wut@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifwut@plain%
    \def\contentsname{\wut@label@en@tocname}
    \def\listfigurename{\wut@label@en@lsfigname}
    \def\listtablename{\wut@label@en@lstabname}
    \def\bibname{\wut@label@en@bibname}
    \def\refname{\wut@label@en@bibname}
    \def\algname{\wut@label@en@algname}
    \def\bibetal{\wut@label@en@bibetal}
    \def\biband{\wut@label@en@biband}
    \def\axiomname{\wut@label@en@axiomname}
    \def\theoremname{\wut@label@en@theoremname}
    \def\lemmaname{\wut@label@en@lemmaname}
    \def\corollaryname{\wut@label@en@corollaryname}
    \def\assertionname{\wut@label@en@assertionname}
    \def\propositionname{\wut@label@en@propositionname}
    \def\conjecturename{\wut@label@en@conjecturename}
    \def\definitionname{\wut@label@en@definitionname}
    \def\examplename{\wut@label@en@examplename}
    \def\remarkname{\wut@label@en@remarkname}
    \def\proofname{\wut@label@en@proofname}
    \def\@title{\wut@value@en@titlemark}
    \def\@author{\wut@value@en@author}
\else
    \def\contentsname{\wut@label@ch@tocname}
    \def\listfigurename{\wut@label@ch@lsfigname}
    \def\listtablename{\wut@label@ch@lstabname}
    \def\algname{\wut@label@ch@algname}
    \def\bibname{\wut@label@ch@bibname}
    \def\refname{\wut@label@ch@bibname}
    \def\bibetal{\wut@label@ch@bibetal}
    \def\biband{\wut@label@ch@biband}
    \def\axiomname{\wut@label@ch@axiomname}
    \def\theoremname{\wut@label@ch@theoremname}
    \def\lemmaname{\wut@label@ch@lemmaname}
    \def\corollaryname{\wut@label@ch@corollaryname}
    \def\assertionname{\wut@label@ch@assertionname}
    \def\propositionname{\wut@label@ch@propositionname}
    \def\conjecturename{\wut@label@ch@conjecturename}
    \def\definitionname{\wut@label@ch@definitionname}
    \def\examplename{\wut@label@ch@examplename}
    \def\remarkname{\wut@label@ch@remarkname}
    \def\proofname{\wut@label@ch@proofname}
    \def\@title{\wut@value@ch@titlemark}
    \def\@author{\wut@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{4}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \arabic{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
\makeatletter
% \renewcommand \@biblabel[1]{\quad\quad[ #1]} %参考文献标号右对齐
\renewcommand\@biblabel[1]{[#1]\hfill} %参考文献标号左对齐

%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput

