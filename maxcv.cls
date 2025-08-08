\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{maxcv}[2025/05/29 Custom CV class]

% Load base class
\LoadClass[a4paper,10pt]{article}

% Packages:
\RequirePackage[
    ignoreheadfoot, % set margins without considering header and footer
    top=2 cm, % seperation between body and page edge from the top
    bottom=2 cm, % seperation between body and page edge from the bottom
    left=2 cm, % seperation between body and page edge from the left
    right=2 cm, % seperation between body and page edge from the right
    footskip=1.0 cm, % seperation between body and footer
    % showframe % for debugging
]{geometry} % for adjusting page geometry
\RequirePackage{titlesec} % for customizing section titles
\RequirePackage{tabularx} % for making tables with fixed width columns
\RequirePackage{array} % tabularx requires this
\RequirePackage[dvipsnames]{xcolor} % for coloring text
\definecolor{primaryColor}{RGB}{0, 0, 0} % define primary color
\RequirePackage{enumitem} % for customizing lists
\RequirePackage{fontawesome5} % for using icons
\RequirePackage{amsmath} % for math
\RequirePackage[
    pdftitle={John Doe's CV},
    pdfauthor={John Doe},
    pdfcreator={LaTeX with RenderCV},
    colorlinks=true,
    urlcolor=primaryColor
]{hyperref} % for links, metadata and bookmarks
\RequirePackage[pscoord]{eso-pic} % for floating text on the page
\RequirePackage{calc} % for calculating lengths
\RequirePackage{bookmark} % for bookmarks
\RequirePackage{changepage} % for one column entries (adjustwidth environment)
\RequirePackage{paracol} % for two and three column entries
\RequirePackage{ifthen} % for conditional statements
\RequirePackage{needspace} % for avoiding page brake right after the section title
\RequirePackage{graphicx} % for including images
\RequirePackage{xstring}
\RequirePackage{iftex} % check if engine is pdflatex, xetex or luatex

% Ensure that generate pdf is machine readable/ATS parsable:
\ifPDFTeX\pdfgentounicode=1
    \RequirePackage[T1]{fontenc}
    \RequirePackage[utf8]{inputenc}
    \RequirePackage{lmodern}
\fi

\RequirePackage{charter}

% Set PDF link colors
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    urlcolor=black
}

% Settings and formatting:
\raggedright{}
\AtBeginEnvironment{adjustwidth}{\partopsep0pt} % remove space before adjustwidth environment
\pagestyle{empty} % no header or footer
\setcounter{secnumdepth}{0} % no section numbering
\setlength{\parindent}{0pt} % no indentation
\setlength{\topskip}{0pt} % no top skip
\setlength{\columnsep}{0.15cm} % set column seperation
\pagenumbering{gobble} % no page numbering
\titleformat{\section}{\needspace{4\baselineskip}\bfseries\large}{}{0pt}{}[\vspace{1pt}\titlerule]
\titlespacing{\section}{
    % left space:
    -1pt
}{
    % top space:
    0.3 cm
}{
    % bottom space:
    0.2 cm
} % section title spacing

% ============================
% CV Metadata Variables
% ============================

\newcommand{\varName}{}     % Required
\newcommand{\varLocation}{} % Required
\newcommand{\varEmail}{}    % Required
\newcommand{\varPhone}{}    % Required
\newcommand{\varGithub}{}  % Optional
\newcommand{\varSocials}{}  % Optional

\newcommand{\name}[1]{\renewcommand{\varName}{#1}}
\newcommand{\location}[1]{\renewcommand{\varLocation}{#1}}
\newcommand{\email}[1]{\renewcommand{\varEmail}{#1}}
\newcommand{\phone}[1]{\renewcommand{\varPhone}{#1}}
\newcommand{\github}[1]{\renewcommand{\varGithub}{#1}}
\newcommand{\socials}[1]{\renewcommand{\varSocials}{#1}}

% ============================
% Format Macros
% ============================

% dashes
\newcommand{\dash}{\textendash}
\newcommand{\emdash}{\textemdash}

% Dot-prefixed word, e.g. \dotword{NET} → .NET
\newcommand{\dotword}[1]{\mbox{.\hspace{0pt}#1}}


% custom bullet points
\renewcommand\labelitemi{$\vcenter{\hbox{\small$\bullet$}}$}
\newenvironment{highlights}{
    \begin{itemize}[
            topsep=0.10 cm,
            parsep=0.10 cm,
            partopsep=0pt,
            itemsep=0pt,
            leftmargin=0 cm + 10pt
        ]
        }{
    \end{itemize}
}

% new environment for highlights
\newenvironment{highlightsforbulletentries}{
    \begin{itemize}[
            topsep=0.10 cm,
            parsep=0.10 cm,
            partopsep=0pt,
            itemsep=0pt,
            leftmargin=10pt
        ]
        }{
    \end{itemize}
}

% Custom spacer command for contact info
\renewcommand{\and}{\hspace{1em}|\hspace{1em}}

% save the original href command in a new command:
\let\hrefWithoutArrow\href{}

% new environment for highlights for bullet entries
\newenvironment{onecolentry}{
    \begin{adjustwidth}{
            0 cm + 0.00001 cm
        }{
            0 cm + 0.00001 cm
        }
        }{
    \end{adjustwidth}
}

% new environment for one column entries
\newenvironment{twocolentry}[2][]{
    \onecolentry
    \def\secondColumn{#2}
    \setcolumnwidth{\fill, 4.5 cm}
    \begin{paracol}{2}
        }{
        \switchcolumn \raggedleft \secondColumn
    \end{paracol}
    \endonecolentry
}

% new environment for two column entries
\newenvironment{threecolentry}[3][]{
    \onecolentry
    \def\thirdColumn{#3}
    \setcolumnwidth{, \fill, 4.5 cm}
    \begin{paracol}{3}
        {\raggedright #2} \switchcolumn
        }{
        \switchcolumn \raggedleft{} \thirdColumn{}
    \end{paracol}
    \endonecolentry
}

% ============================
% CV Header Macro
% ============================

\newcommand{\CVHeader}{%
    \begin{center}
        {\LARGE \textbf{\varName}}\\[0.5em]
        \varLocation \and \varEmail \and \varPhone
        \if\varGithub\empty
        \else
            \and \href{\varGithub}{\StrBehind{\varGithub}{https://}}
        \fi\if\varSocials\empty\else\\[0.5em]\fi
        \if\varSocials\empty
        \else
            \url{\varSocials}
        \fi
    \end{center}
    % \vspace{1em}
}

% ============================
% Skill Entry Macro
% ============================

% ========== Skill Tag Styling ==========
\RequirePackage{xparse}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins}

% Define single skill tag box
\newtcbox{\SkillTag}{nobeforeafter, colframe=black!50!gray, colback=gray!10,
    boxrule=0.4pt, arc=4pt, boxsep=2pt, left=4pt, right=4pt, top=2pt, bottom=2pt, height=1.5em,
    fontupper=\sffamily\small}

% ========== Skill Macros ==========
\NewDocumentCommand{\SkillSection}{m m}{%
    \section*{#1}%
    \noindent
    \foreach \skill in {#2} {%
            \SkillTag{\skill} \hspace{0.5em}%
        }
}
% Inline Skill Tag List (no section title)
\NewDocumentCommand{\SkillTagsInline}{m}{%
    \mbox{}\\
    \foreach \skill in {#1} {%
            \SkillTag{\skill} \hspace{0.4em}%
        }%
}

% ============================
% Extra Macros
% ============================

% Safe macro for C++
\newcommand{\cplusplus}{C\kern-.1em\raisebox{0.2ex}{\texttt{++}}}
\newcommand{\csharp}{C\raisebox{-0.1ex}{\large\texttt{\#}}}

