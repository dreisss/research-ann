%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Classe desenvolvida para o ERMAC 2025 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ermacrs2025C}
\typeout{Carregando a classe ERMAC 2025.}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carrega a classe padrão de artigo %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[a4paper, twoside]{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pacotes necessários para o adequado funcionamento da classe %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[style=ieee,sortcites=true,sorting=nyt,backend=biber,language=brazilian]{biblatex}

\RequirePackage{csquotes} % para citações
\RequirePackage{titlesec} % personalizar as seções
\RequirePackage{amsmath,amssymb,amsthm} % pacotes matemáticos básicos
\RequirePackage{graphicx} % básico para figura
\RequirePackage{indentfirst} % indenta sempre o primeiro parágrafo
\RequirePackage{xcolor} % para definir cores
\RequirePackage{makerobust} % define \MakeUppercase entre outros
\RequirePackage{geometry} % Margens
\RequirePackage{icomma} % corrige espaçamento quando vírgula é
% utilizada como separador decimal
\RequirePackage{booktabs} % melhorar exemplo de tabela
\RequirePackage{tabularx} % tabelas
\RequirePackage{multirow}
\RequirePackage{fancyhdr} % Cabeçalhos
\RequirePackage{caption} % para definir a fonte e alinhamento das legendas
\RequirePackage{hyperref}
\RequirePackage{etoolbox}
\RequirePackage{enumitem}
\RequirePackage{float}
\RequirePackage{subcaption}
\RequirePackage{algorithm2e}

\DeclareLanguageMapping{brazilian}{brazilian-apa}
\DefineBibliographyStrings{brazilian}{%
  references = {Referências},
  in = {em},
  editor = {editor},
  editors = {editores},
  andothers = {et\addabbrvspace al\adddot}
}
\addbibresource{references.bib}
% Alterar para ordenar por nome
\DeclareNameAlias{default}{given-family}

%%%%%%%%%%%%%%%%%%%%%%%%%
% Coleta de informações %
%%%%%%%%%%%%%%%%%%%%%%%%%

\ExplSyntaxOn

%%% Autores, filiações e emails %%%
% Variáveis para autores, filiações e emails
\seq_new:N \g_authors_seq
\seq_new:N \g_affiliations_seq
\seq_new:N \g_emails_seq
\int_new:N \g_author_count_int

% Comando autor
\RenewDocumentCommand \author { m m m }{
  \int_gincr:N \g_author_count_int
  \seq_gput_right:Nn \g_authors_seq { #1 }
  \seq_gput_right:Nn \g_affiliations_seq { #2 }
  \seq_gput_right:Nn \g_emails_seq { #3 }
}

% Comando para mostrar nomes dos autores
\NewDocumentCommand \printauthornames { }{
  \seq_indexed_map_inline:Nn \g_authors_seq{
    ##2\textsuperscript{##1}
    \int_compare:nNnF { ##1 } = { \g_author_count_int } { ,\space }
  }
}

% Comando para imprimir nomes dos autores sem formatação
\NewDocumentCommand \printplainauthors { }{
  \seq_use:Nn \g_authors_seq { ,~ }
}

% Comando para mostrar filiações e emails
\NewDocumentCommand \printaffiliations { }{
  \seq_indexed_map_inline:Nn \g_affiliations_seq
  {
    \textsuperscript{##1}##2,\space \href{mailto:\seq_item:Nn
    \g_emails_seq {##1}}{\texttt{\seq_item:Nn \g_emails_seq {##1}}}\par
  }
}

%%% Palavras-chave %%%
% Variáveis para keywords
\seq_new:N \g_keywords_seq
\tl_new:N \g_keywords_title_tl
\tl_gset:Nn \g_keywords_title_tl {Palavras-chave} % título padrão

% Comando para definir título
\NewDocumentCommand \keywordstitle { m }{
  \tl_gset:Nn \g_keywords_title_tl { #1 }
}

% Comando para adicionar palavra-chave
\NewDocumentCommand \keyword { m }{
  \seq_gput_right:Nn \g_keywords_seq { #1 }
}

% Comando para imprimir palavras-chave
\NewDocumentCommand \printkeywords { }{
  \textbf{\tl_use:N \g_keywords_title_tl.}~
  \int_step_inline:nn { \seq_count:N \g_keywords_seq }
  {
    \seq_item:Nn \g_keywords_seq { ##1 }
    \int_compare:nNnTF { ##1 } = { \seq_count:N \g_keywords_seq }
    { . }
    { ; \space }
  }
}

%%% Resumo %%%
% Variáveis para resumo
\tl_new:N \g_abstract_text_tl
\tl_new:N \g_abstract_title_tl
\tl_gset:Nn \g_abstract_title_tl {Resumo} % título padrão

% Comando para definir título
\NewDocumentCommand \abstracttitle { m }{
  \tl_gset:Nn \g_abstract_title_tl { #1 }
}

% Comando para adicionar texto do resumo
\RenewDocumentCommand \abstract { m }{
  \tl_gset:Nn \g_abstract_text_tl { #1 }
}

% Comando para imprimir resumo
\NewDocumentCommand \printabstract { }{
  \par\noindent
  \textbf{\tl_use:N \g_abstract_title_tl.}~
  \tl_use:N \g_abstract_text_tl
  \par
}

%%% Sessão Técnica %%%
% Variável para ST
% \tl_new:N \g_st_tl
% \tl_gset:Nn \g_st_tl {Sem~ST}

% Comando para definir ST
% \NewDocumentCommand \setST { m }{
%   \tl_gset:Nn \g_st_tl { #1 }
% }

% Comando para imprimir ST
% \NewDocumentCommand \printST { }{
%   \tl_use:N \g_st_tl
% }

%%% Referências %%%
% Variável para o título das referências
\tl_new:N \g_references_title_tl
\tl_gset:Nn \g_references_title_tl {Referências}

% Comando para alterar o título das referências
\NewDocumentCommand \referencestitle { m }{
  \tl_gset:Nn \g_references_title_tl { #1 }
}

% Define o comando printreferences
\NewDocumentCommand \printreferences { }{
  \printbibliography[heading=bibintoc,title={\tl_use:N \g_references_title_tl}]
}

%%% Teoremas %%%
% Variável para o título dos teoremas
\tl_new:N \g_theorem_title_tl
\tl_gset:Nn \g_theorem_title_tl {Teorema}

% Comando para alterar o título dos teoremas
\NewDocumentCommand \theoremtitle { m }{
  \tl_gset:Nn \g_theorem_title_tl { #1 }
}

% Definição do ambiente theorem
\newtheorem{theorem}{\tl_use:N \g_theorem_title_tl}[section]

%%% Corolários %%%
% Variável para o título dos corolários
\tl_new:N \g_corollary_title_tl
\tl_gset:Nn \g_corollary_title_tl {Corolário}

% Comando para alterar o título dos corolários
\NewDocumentCommand \corollarytitle { m }{
  \tl_gset:Nn \g_corollary_title_tl { #1 }
}

% Definição do ambiente corollary
\newtheorem{corollary}{\tl_use:N \g_corollary_title_tl}[section]

%%% Lemas %%%
% Variável para o título dos lemas
\tl_new:N \g_lemma_title_tl
\tl_gset:Nn \g_lemma_title_tl {Lema}

% Comando para alterar o título dos lemas
\NewDocumentCommand \lemmatitle { m }{
  \tl_gset:Nn \g_lemma_title_tl { #1 }
}

% Definição do ambiente lemma
\newtheorem{lemma}{\tl_use:N \g_lemma_title_tl}[section]

%%% Definição %%%
% Variável para o título das definições
\tl_new:N \g_definition_title_tl
\tl_gset:Nn \g_definition_title_tl {Definição}

% Comando para alterar o título das definições
\NewDocumentCommand \definitiontitle { m }{
  \tl_gset:Nn \g_definition_title_tl { #1 }
}

% Definição do ambiente definição
\newtheorem{definition}{\tl_use:N \g_definition_title_tl}[section]

%%% Proposição %%%
% Variável para o título das proposições
\tl_new:N \g_proposition_title_tl
\tl_gset:Nn \g_proposition_title_tl {Proposição}

% Comando para alterar o título das proposições
\NewDocumentCommand \propositiontitle { m }{
  \tl_gset:Nn \g_proposition_title_tl { #1 }
}

% Definição do ambiente proposição
\newtheorem{proposition}{\tl_use:N \g_proposition_title_tl}[section]

%%% Destaque %%%
% Variável para o título dos destaques
\tl_new:N \g_remark_title_tl
\tl_gset:Nn \g_remark_title_tl {Destaque}

% Comando para alterar o título dos destaques
\NewDocumentCommand \remarktitle { m }{
  \tl_gset:Nn \g_remark_title_tl { #1 }
}

% Definição do ambiente destaque
\newtheorem{remark}{\tl_use:N \g_remark_title_tl}[section]

\ExplSyntaxOff

\def\portuguese{
  \usepackage[brazil]{babel}
}

\def\english{
  \usepackage[english]{babel}
  \abstracttitle{Abstract}
  \keywordstitle{Keywords}
  \theoremtitle{Theorem}
  \corollarytitle{Corollary}
  \lemmatitle{Lemma}
  \definitiontitle{Definition}
  \propositiontitle{Proposition}
  \remarktitle{Remark}
  \referencestitle{References}
}

% Título
\renewcommand{\title}[1]{
  \fullTitle{#1}
}

\def\@fullTitle{Um título é necessário.}
\newcommand{\fullTitle}[1]{
  \def\@fullTitle{#1}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configurações da página %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newgeometry{
  bottom = 2.5cm,
  top = 1.25cm,
  left = 2.5cm,
  right = 2.5cm,
  headheight = 27.15pt
}

\linespread{1.5}
\setlength{\parindent}{1.0cm} % Tamanho da indentação do parágrafo.
\AtBeginEnvironment{thebibliography}{
  \linespread{1}
  \selectfont
  \setlength{\bibsep}{12pt}
}
\setlist{nosep}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fontes, tamanhos, enumerações, legendas, cores e links %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tamanhos das fontes
\renewcommand{\scriptsize}{\fontsize{8}{8.5pt}\selectfont}
\renewcommand{\footnotesize}{\fontsize{9}{9pt}\selectfont}
\renewcommand{\small}{\fontsize{10}{11pt}\selectfont}
\renewcommand{\normalsize}{\fontsize{12}{12.5pt}\selectfont}
\renewcommand{\large}{\fontsize{14}{14.5pt}\selectfont}

% Configura legendas.
\captionsetup{%
  % font=small,
  labelfont=bf,
  singlelinecheck=false,
  labelsep=period,
  justification=centering
}

\captionsetup[subfigure]{%
  font=footnotesize,
  labelfont=bf,
  singlelinecheck=false,
  justification=centering       % alinhamento
}

% Define as cores e aplica a corBase ao documento
\definecolor{corBase}{rgb}{0.2, 0.2, 0.2} % cinza quase preto - cansa
% menos o leitor
\AtBeginDocument{\color{corBase}} % estabelece a cor como padrão para
% o documento

% Configura os links
\hypersetup{
  colorlinks=true,
  linkcolor=corBase,
  filecolor=corBase,
  urlcolor=corBase,
  citecolor=corBase,
  pdfstartview={FitH}
}

% \AtBeginDocument{
%   \hypersetup{
%     pdftitle={\@fullTitle},
%     % pdfauthor={\printplainauthors},
%     pdfsubject={ERMAC-RS 2025},
%     %     pdfkeywords={\@keywordsContent}
%   }
% }

%%%%%%%%%%
% Seções %
%%%%%%%%%%
% Configura a exibição das seções.
\titleformat{\section}[block]{\bf\raggedright\normalsize}{\thesection.}{1em}{\MakeUppercase}[]
\titlespacing*{\section}{0pt}{1.5em}{0.75em}[0pt]

% Configura a exibição das subseções.
\titleformat{\subsection}[block]{\bf\raggedright\normalsize}{\thesubsection.}{1em}{}[]
\titlespacing*{\subsection}{0pt}{1.5em}{0.75em}[0pt]

% Configura a exibição das subsubseções.
\titleformat{\subsubsection}[block]{\it\raggedright\normalsize}{\thesubsubsection.}{1em}{}[]
\titlespacing*{\subsubsection}{0pt}{1em}{1em}[0pt]

% Configura a exibição dos parágrafos.
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
  {3.25ex \@plus1ex \@minus.2ex}%
  {-1em}%
{\normalfont\normalsize\bfseries\SS@parafont}}

% Configura a exibição dos subparágrafos.
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
  {3.25ex \@plus1ex \@minus .2ex}%
  {-1em}%
{\normalfont\normalsize\bfseries\SS@subparafont}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ambientes para teoremas, proposições, etc. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareMathOperator{\sen}{sen}
\DeclareMathOperator{\arcsen}{arcsen}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configurações dos cabeçalhos e rodapés %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}

% Header da primeira página.
% \fancypagestyle{empty}{%
%   \renewcommand{\headrulewidth}{0pt}%
%   \fancyhf{}%
%   \fancyhead[L]{\footnotesize{\color{corBase}\emph{XII ERMAC-RS -- 02
%         a 04 de julho de 2025 \\ Encontro Regional de Matem\'{a}tica
%         Aplicada e Computacional do Rio Grande do Sul \\ IME-UFRGS, Campus
%   do Vale, Porto Alegre}}}%
%   \fancyfoot[R]{\thepage}
%   \fancyfoot[L]{\printST}
% }

% Header das páginas subsequentes.
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhead[CE]{{}}
\fancyhead[CO]{{}}
\rfoot{\thepage}
% \lfoot{\printST}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Impressão de título, nomes, filiação, e-mail, resumo e palavras
% chave %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\maketitle{%
  \linespread{1.0}
  \newpage\thispagestyle{empty}
  \null
  \vskip 0em%
  \begin{center}%
    \let \footnote \thanks
    {\huge \bf {\@fullTitle} \par}%
  \end{center}%
  \vskip 0.1em%
  {\normalsize
    \lineskip .5em%
    \begin{minipage}[b]{\textwidth}
      \centering\printauthornames
    \end{minipage}
    \par
  }%
  {\scriptsize
    \lineskip 1.5em%
    \begin{minipage}[b]{\textwidth}
      \printaffiliations
    \end{minipage}
  \par}%
  \vskip 1em%
  {\small
    \lineskip .5em%
    \centering
    \begin{minipage}[b]{\textwidth}
      \printabstract
      \par\vskip 1em
      \printkeywords
  \end{minipage}\par}%
  \par
  \vskip 1em
}

\def\maketitleblind{%
  \def\maketitle{%
    \linespread{1.0}
    \newpage\thispagestyle{empty}
    \null
    \vskip 0em%
    \begin{center}%
      \let \footnote \thanks
      {\large \bf {\@fullTitle} \par}%
    \end{center}%
    \vskip 1.5em%
    {\normalsize
      \lineskip .5em%
      \begin{minipage}[b]{\textwidth}
        \centering\phantom{\printauthornames}
      \end{minipage}
      \par
    }%
    {\scriptsize
      \lineskip 1.5em%
      \phantom{
        \begin{minipage}[b]{\textwidth}
          \printaffiliations
        \end{minipage}
      }
    \par}%
    \vskip 1em%
    {\small
      \lineskip .5em%
      \centering
      \begin{minipage}[b]{\textwidth}
        \printabstract
        \par\vskip 1em
        \printkeywords
    \end{minipage}\par}%
    \par
    \vskip 1em
  }
}

\renewcommand{\arraystretch}{1.3}
