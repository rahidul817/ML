%%
%% ICCA 2026 — ACM LaTeX Template (sigconf)
%% Group 11: A Self-Healing Multi-Agent Framework for Adversarially Robust NIDS
%%

\documentclass[sigconf]{acmart}

%% ------------------------------------------------------------------
%% ACM / ICCA metadata (matching template exactly)
%% ------------------------------------------------------------------
\setcopyright{acmlicensed}
\copyrightyear{2026}
\acmYear{2026}
\acmDOI{XXXXXXX.XXXXXXX}
\acmConference[ICCA 2026]{4th International Conference on Computing Advancements}{October 15--16, 2026}{Dhaka, Bangladesh}
\acmISBN{978-1-4503-XXXX-X/2026/10}

%% Remove default ACM reference footer for submission
\settopmatter{printacmref=false}
\renewcommand\footnotetextcopyrightpermission[1]{}
\pagestyle{plain}

%% ------------------------------------------------------------------
%% Packages
%% ------------------------------------------------------------------
\usepackage{booktabs}
\usepackage{multirow}
\usepackage{graphicx}
\usepackage{amsmath}
\usepackage{hyperref}
\usepackage{array}
\usepackage{balance}
\usepackage{flafter}
% Allow text to share pages with figures instead of forcing float-only pages.
\setcounter{topnumber}{3}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{5}
\setcounter{dbltopnumber}{2}
\renewcommand{\topfraction}{0.90}
\renewcommand{\bottomfraction}{0.80}
\renewcommand{\textfraction}{0.08}
\renewcommand{\floatpagefraction}{0.75}
\renewcommand{\dbltopfraction}{0.90}
\renewcommand{\dblfloatpagefraction}{0.75}
\setlength{\textfloatsep}{10pt plus 2pt minus 2pt}
\setlength{\floatsep}{8pt plus 2pt minus 2pt}
\setlength{\intextsep}{8pt plus 2pt minus 2pt}
\setlength{\dbltextfloatsep}{10pt plus 2pt minus 2pt}
\setlength{\dblfloatsep}{8pt plus 2pt minus 2pt}

\usepackage{placeins}
\graphicspath{{figures/}}


%% ------------------------------------------------------------------
\begin{document}
\raggedbottom

\title[Self-Healing Multi-Agent Network Intrusion Detection]{A Self-Healing Multi-Agent Framework for Adversarially Robust
Network Intrusion Detection: Integrating Ensemble Learning,
Threshold Optimization, and Neural Network Approaches on NSL-KDD}

\renewcommand{\shortauthors}{Sujan et al.}

\author{Nabib Ahamed Sujan}
\affiliation{%
  \institution{American International University-Bangladesh (AIUB)}
  \city{Dhaka}
  \country{Bangladesh}}
\email{23-51193-1@student.aiub.edu}

\author{Md Rahidul Islam}
\affiliation{%
  \institution{American International University-Bangladesh (AIUB)}
  \city{Dhaka}
  \country{Bangladesh}}
\email{23-51269-1@student.aiub.edu}

\author{Ashraful Hossain}
\affiliation{%
  \institution{American International University-Bangladesh (AIUB)}
  \city{Dhaka}
  \country{Bangladesh}}
\email{23-50722-1@student.aiub.edu}

\author{Ankita Islam Anka}
\affiliation{%
  \institution{American International University-Bangladesh (AIUB)}
  \city{Dhaka}
  \country{Bangladesh}}
\email{23-53768-3@student.aiub.edu}

%% ------------------------------------------------------------------
%% CCS Concepts (required by ACM template)
%% ------------------------------------------------------------------
\begin{CCSXML}
<ccs2012>
 <concept>
  <concept_id>10010147.10010257.10010293.10010294</concept_id>
  <concept_desc>Computing methodologies~Neural networks</concept_desc>
  <concept_significance>500</concept_significance>
 </concept>
 <concept>
  <concept_id>10010147.10010257.10010258.10010259</concept_id>
  <concept_desc>Computing methodologies~Supervised learning by classification</concept_desc>
  <concept_significance>300</concept_significance>
 </concept>
 <concept>
  <concept_id>10002978.10002986.10002990</concept_id>
  <concept_desc>Security and privacy~Intrusion detection systems</concept_desc>
  <concept_significance>500</concept_significance>
 </concept>
</ccs2012>
\end{CCSXML}

\ccsdesc[500]{Computing methodologies~Neural networks}
\ccsdesc[300]{Computing methodologies~Supervised learning by classification}
\ccsdesc[500]{Security and privacy~Intrusion detection systems}

%% ------------------------------------------------------------------
\begin{abstract}
Modern networks face increasingly sophisticated intrusion tactics,
including adversarial on-manifold attacks, zero-day exploits, and
data-drift-induced model degradation. Existing Network Intrusion
Detection Systems (NIDS) rely on static, single-model architectures
that fail to generalize across heterogeneous threat landscapes. This
paper proposes and evaluates a multi-model ensemble strategy on the
NSL-KDD benchmark dataset, comparing Random Forest (default and
class-balanced), threshold-optimized RF, XGBoost, and a Deep Neural
Network (DNN). After comprehensive preprocessing---including
IQR-based outlier capping, Standard Scaling, and label encoding---four
models were trained and benchmarked. The threshold-tuned RF achieved
\textbf{96.87\% accuracy} with a ROC-AUC of \textbf{0.9833},
significantly outperforming baseline approaches. Feature importance
analysis reveals that destination bytes, source bytes, and connection
count are the most discriminative features. Our findings demonstrate
that adaptive threshold calibration combined with ensemble learning
provides a robust, computationally feasible foundation toward a
self-healing, autonomously adaptive NIDS.
\end{abstract}

\keywords{Network Intrusion Detection, NSL-KDD, Random Forest,
XGBoost, Ensemble Learning, Threshold Optimization, Adversarial
Robustness, Deep Neural Network, Self-Healing Systems}

\maketitle

%% ==================================================================
\section{Introduction}
%% ==================================================================

\subsection{Background}

The exponential proliferation of IoT devices, Industry~4.0
infrastructure, and software-defined networking environments has
dramatically expanded the cyberattack surface available to malicious
actors~\cite{shukla2023uindesi,neto2023cicion}. Modern networks generate
enormous volumes of heterogeneous traffic in real time, making the timely
and accurate identification of intrusions a formidable
challenge~\cite{ahmad2021anomaly}. Cyber adversaries have evolved beyond
simple volumetric flooding; today's threat landscape includes Advanced
Persistent Threats (APTs) employing stealthy, long-duration evasion
campaigns~\cite{ahmed2014gp}, DDoS attacks timed to exploit firmware
update windows~\cite{dong2019survey}, and adversarial examples
specifically engineered to deceive ML-based
detectors~\cite{alfawareh2025onoff}.

Network Intrusion Detection Systems (NIDS) constitute a critical
defensive layer in this environment. Their effectiveness depends on
accuracy, latency, computational efficiency, and adaptability to
distributional shifts in traffic patterns. Machine learning has driven
significant improvements in NIDS performance, yet several fundamental
gaps persist in the current state-of-the-art that prevent these systems
from operating with true autonomy and resilience.

\subsection{Problem Statement}

Despite substantial advances in ML-based NIDS, three key vulnerabilities
remain inadequately addressed. First, standard classifiers are
susceptible to \emph{on-manifold} adversarial attacks---malicious traffic
crafted to statistically resemble benign data---resulting in unacceptably
high false-negative rates~\cite{alfawareh2025onoff}. Second, static
models trained on historical datasets suffer from catastrophic forgetting
and data drift when attack distributions shift~\cite{berardi2023operation,
channappayya2023augmented}. Third, existing systems lack end-to-end
autonomy: upon detecting anomalies, they still depend on human analysts
for interpretation and response, introducing dangerous latency into the
defensive loop~\cite{bangui2022hybrid,folino2023ensemble}.

The NSL-KDD dataset, while a standard benchmark, presents its own
challenges: significant class imbalance between normal and attack traffic,
the presence of 39 distinct attack subtypes, and distributional
differences between training and test sets that simulate real-world
generalization difficulty. These properties make it an ideal testbed for
evaluating robust classification strategies.

\subsection{Research Gap}

A review of the current literature reveals that while individual
components of a robust NIDS---ensemble classifiers, Transformer-based
traffic analysis, continual learning, federated privacy, and LLM-driven
reasoning---have each been studied in isolation, no unified framework
coordinates them into a self-healing, autonomous defense
system~\cite{kheddar2025transformers,ahmad2021anomaly,
channappayya2023augmented}. Specifically, there is no published work that
simultaneously addresses adversarial robustness through ensemble
calibration, distributional shift through adaptive memory replay, and
zero-intervention incident response through LLM-driven mitigation within
a single deployable architecture.

\subsection{Research Objectives}

This work addresses the stated gap through the following concrete
objectives:
\begin{itemize}
  \item Design and evaluate a multi-model pipeline on NSL-KDD that
    establishes empirical baselines for Random Forest, XGBoost, and DNN
    architectures.
  \item Demonstrate the impact of class-balancing and threshold
    optimization on detection of minority attack classes.
  \item Identify the most discriminative network features via feature
    importance analysis to inform future LLM-based reasoning modules.
  \item Propose an architectural roadmap for extending the current
    empirical system toward a fully autonomous, self-healing NIDS
    framework.
\end{itemize}

%% ==================================================================
\section{Literature Review}
%% ==================================================================

\subsection{Adversarial Robustness and Zero-Day Detection}

On-manifold adversarial attacks remain a critical blind spot for NIDS.
Al-Fawa'reh et al.~\cite{alfawareh2025onoff} demonstrated that standard
out-of-distribution detection models fail catastrophically against
adversarial traffic that mimics normal data statistics, proposing
invertible transformation techniques applied to latent spaces with
differential entropy shifts as a countermeasure. Zero-day attack detection
has been approached through zero-shot learning frameworks and unsupervised
graph-based tools such as D-MAGIC, which maps network flows visually to
identify coordinated strikes without prior signature
knowledge~\cite{folino2023ensemble}. The HERO
framework~\cite{masud2025explainable} further decouples data
representation from detection logic, enabling anomaly identification
directly from raw high-dimensional traffic vectors.

\subsection{Ensemble Learning and Feature Engineering}

The massive scale and inherent imbalance of cyber threat data necessitate
sophisticated feature engineering. Genetic Programming has proven
effective at automating feature construction for multi-stage APT
detection~\cite{ahmed2014gp}. The HYRIDE
framework~\cite{shukla2023uindesi} combines hybrid feature selection with
unsupervised outlier detection, substantially reducing false alarms in
industrial network environments. Grouping deep learning models---including
Random Forests, CatBoost, and LSTMs---alongside vulnerability scoring
metrics such as EPSS yields robust feature representations and
interpretable detection alerts~\cite{bangui2022hybrid,attaran2024digital}.
Our work builds directly on this tradition by evaluating RF and XGBoost
ensembles with explicit class-balancing and threshold calibration on
NSL-KDD.

\subsection{Transformer Models and LLM-Driven Traffic Analysis}

Attention mechanisms have transformed sequential data analysis. Yin
et al.~\cite{yin2017deep} demonstrated that recurrent neural networks
capture temporal dependencies in intrusion detection with strong results.
Vision Transformers have been repurposed for IoT traffic protection,
treating network flows as images~\cite{dong2019survey}. The MEGA+MAF
architecture~\cite{ahmad2021anomaly} uses adaptive gating to fuse short-
and long-term temporal patterns with low computational overhead.
Kheddar~\cite{kheddar2025transformers} provides a comprehensive survey
confirming that LLMs hold transformative potential for intrusion detection
when properly integrated with structured threat databases and
action-generation modules.

\subsection{Continual Learning and Self-Healing Mechanisms}

Sustaining detection performance over time requires continual learning.
In Industrial IoT contexts, hybrid digital twins enable NIDS to mirror
physical devices and adapt to new attack vectors without costly offline
retraining~\cite{berardi2023operation}. Task-Aware Memory Replay (TAMR)
models intelligently prioritize retention of critical historical attack
signatures while absorbing new threat patterns, achieving strong balance
between plasticity and stability~\cite{channappayya2023augmented}. These
mechanisms form the theoretical backbone of the self-healing component
proposed in our framework extension.

\subsection{Federated Learning and Multi-Agent Systems}

Privacy-preserving distributed training through federated
learning~\cite{agrawal2022federated} allows network nodes to
collaboratively improve detection models without exposing raw traffic
data. The SAFE-IDS framework addresses federated learning's vulnerability
to uneven data distributions through gradient aggregation adjustments.
Graph Neural Networks combined with decentralized SDN architectures enable
rapid DoS defense at the network edge~\cite{sun2024gnnids}. Together,
these technologies provide the infrastructure foundation for multi-agent
deployment of the proposed self-healing system.

%% ==================================================================
\section{Methodology and System Architecture}
%% ==================================================================

\subsection{Dataset}

All experiments were conducted on the NSL-KDD benchmark dataset---a
refined version of KDD Cup~1999 with duplicate records removed. The
training set (KDDTrain+) contains 125,973 records and the test set
(KDDTest+) contains 22,544 records. Each record comprises 41 features
covering basic connection attributes (duration, protocol type, service,
flag, source/destination bytes), content-based features (login failures,
compromised conditions, root shells), and traffic-based statistical
features (connection counts, error rates). The class label encodes 39
attack subtypes grouped under four canonical categories---DoS, Probe,
R2L, U2R---plus normal traffic.

The dataset exhibits pronounced class imbalance: normal traffic and DoS
attacks dominate the training set, while R2L and U2R attacks account for
a small minority. This imbalance directly motivates our use of
class-weighted training and threshold optimization.


Figure~\ref{fig:classes} shows the training-label distribution and its
binary grouping (67,343 normal and 58,630 attack records).
Figures~\ref{fig:protocols} and~\ref{fig:services} summarize the protocol
mix and most frequent services in the saved notebook outputs.

\begin{figure*}[!t]
\centering
\includegraphics[width=0.92\textwidth]{class_distribution.png}
\caption{NSL-KDD training-label frequencies (left) and normal-versus-attack counts (right), extracted from the supplied Colab notebook.}
\Description{NSL-KDD training-label frequencies (left) and normal-versus-attack counts (right), extracted from the supplied Colab notebook.}
\label{fig:classes}
\end{figure*}

\begin{figure}[!tbp]
\centering
\includegraphics[width=0.66\linewidth]{protocol_distribution.png}
\caption{Protocol distribution in KDDTrain+: TCP 81.5\%, UDP 11.9\%, and ICMP 6.6\%.}
\Description{Protocol distribution in KDDTrain+: TCP 81.5\%, UDP 11.9\%, and ICMP 6.6\%.}
\label{fig:protocols}
\end{figure}

\begin{figure}[!tbp]
\centering
\includegraphics[width=\linewidth]{service_distribution.png}
\caption{Ten most frequent network services in the training set.}
\Description{Ten most frequent network services in the training set.}
\label{fig:services}
\end{figure}

\subsection{Preprocessing Pipeline}

\subsubsection{Categorical Encoding}
Three categorical features---\texttt{protocol\_type} (tcp, udp, icmp),
\texttt{service} (66 unique values), and \texttt{flag} (11 unique
values)---were encoded using \texttt{LabelEncoder}. The encoder was fit
on the combined vocabulary of training and test sets to prevent
unseen-category errors during inference.

\subsubsection{Outlier Capping}
Numeric features in network traffic data frequently exhibit extreme
outliers (e.g., \texttt{src\_bytes} spanning 10 orders of magnitude).
IQR-based capping was applied: values below $Q_1 - 1.5 \cdot
\text{IQR}$ were clipped to the lower fence and values above $Q_3 +
1.5 \cdot \text{IQR}$ to the upper fence. This transformation was fit on
training data and applied identically to test data, preventing data
leakage.

\subsubsection{Standard Scaling}
Following outlier capping, all numeric features were z-score normalized
using \texttt{StandardScaler} (fit on training data only). This step is
essential for the DNN component and beneficial for feature interactions
in tree ensembles.

\subsubsection{Target Encoding and Train/Validation Split}
For binary classification (Normal vs.\ Attack), labels were encoded as 0
(normal) and 1 (attack). A \texttt{LabelEncoder} fit on the union of
training and test labels handles the 14 attack subtypes present in the
test set but absent from training. The training set was split 80/20 into
train and validation subsets using stratified sampling.


Figures~\ref{fig:dst-outliers} and~\ref{fig:src-outliers} visualize the
uncapped byte-count distributions. Figure~\ref{fig:correlation} shows
the 12 numeric features selected in the notebook by their mean absolute
pairwise correlation; these are not the model's importance-ranked features.

\begin{figure}[!tbp]
\centering
\includegraphics[width=\linewidth]{destination_outliers.png}
\caption{Destination-byte outliers before preprocessing. The original linear scale is retained.}
\Description{Destination-byte outliers before preprocessing. The original linear scale is retained.}
\label{fig:dst-outliers}
\end{figure}

\begin{figure}[!tbp]
\centering
\includegraphics[width=\linewidth]{source_bytes.png}
\caption{Source bytes grouped by normal and attack labels before preprocessing.}
\Description{Source bytes grouped by normal and attack labels before preprocessing.}
\label{fig:src-outliers}
\end{figure}

\begin{figure*}[!t]
\centering
\includegraphics[width=0.82\textwidth]{correlation.png}
\caption{Pairwise correlation heatmap for the 12 numeric features selected by mean absolute correlation in the notebook.}
\Description{Pairwise correlation heatmap for the 12 numeric features selected by mean absolute correlation in the notebook.}
\label{fig:correlation}
\end{figure*}

\subsection{Model Architectures}

\subsubsection{Random Forest --- Default}
A Random Forest with 100 estimators, maximum depth of 20, and minimum 5
samples per split was trained as the baseline. The default decision
threshold of 0.5 was applied at inference time.

\subsubsection{Random Forest --- Class-Balanced}
A second RF was trained with \texttt{class\_weight=`balanced'}, 200
estimators, and unlimited depth. The balanced weighting inversely scales
sample weights by class frequency, effectively oversampling minority
attack classes during tree construction. This model served as the primary
candidate for threshold optimization.

\subsubsection{Threshold-Optimized RF}
The class-balanced RF produces calibrated probability scores. To find the
optimal operating point, the ROC curve was computed and the threshold
maximizing $\text{TPR} - \text{FPR}$ (Youden's J statistic) was
identified. This threshold, found to be below 0.5, was applied to convert
probability scores to binary predictions, substantially improving attack
recall.

\subsubsection{XGBoost}
An XGBoost classifier with 300 estimators, depth 8, and learning rate
0.1 was trained. Class imbalance was addressed via
\texttt{scale\_pos\_weight} (ratio of negative to positive training
samples), adjusting the gradient computation analogously to class
weighting in RF. Early stopping was monitored on the validation set via
log-loss.

\subsubsection{Deep Neural Network (DNN)}
A fully connected DNN was implemented in TensorFlow/Keras:
\[
\begin{aligned}
\text{Input}(d)&\to\text{Dense}(128,\text{ReLU})\\
&\to\text{Dropout}(0.3)\\
&\to\text{Dense}(64,\text{ReLU})\\
&\to\text{Dropout}(0.3)\\
&\to\text{Dense}(32,\text{ReLU})\\
&\to\text{Dense}(1,\sigma).
\end{aligned}
\]
The saved notebook uses $d=42$, retaining the dataset's difficulty
metadata alongside its 41 traffic features. A deployment-oriented
evaluation should exclude this metadata and repeat training.

Compiled with Adam optimizer and binary cross-entropy loss; trained for
20 epochs with batch size 256.

\subsection{Evaluation Metrics}

Models were evaluated using Accuracy, Precision, Recall, F1-Score, and
ROC-AUC. Accuracy alone is insufficient for imbalanced datasets;
F1-Score provides a harmonic mean of precision and recall, while ROC-AUC
measures discriminative ability across all thresholds. Confusion matrices
were generated for both validation and test sets.

\subsection{System Architecture Overview}

The proposed self-healing framework integrates four conceptual layers:
\begin{enumerate}
  \item \textbf{Sensing Layer:} Real-time packet capture and feature
    extraction.
  \item \textbf{Detection Layer:} Ensemble classifier with
    threshold-optimized binary prediction (implemented and validated in
    this paper).
  \item \textbf{Reasoning Layer} (future work): LLM-driven agent parsing
    anomaly context and generating incident explanations and automated
    mitigation strategies.
  \item \textbf{Adaptive Layer} (future work): Continual learning with
    TAMR-style memory replay to prevent model drift under distributional
    shift.
\end{enumerate}

%% ==================================================================
\section{Results}
%% ==================================================================


\paragraph{Figure provenance and evaluation status.}
The figures added in this version are original saved PNG outputs from
the supplied \href{https://colab.research.google.com/drive/1TTaCEIvHOEDaiMupjHcWk454juObRMsm}{Colab notebook}.
The numerical claims retained from the original manuscript must be read
with the following qualifications. The notebook chooses its threshold
using the test labels (\texttt{best\_thresh}=0.0350), so the reported
96.87\% is a test-tuned result, not an independent held-out estimate.
Its earlier saved confusion matrices belong to a different, incorrectly
aligned-label training run (Section~\ref{sec:diagnostics}). Several
later dashboard cells use synthetic data or hard-coded metrics; those
dashboards are excluded. The DNN test-performance claim in the original
manuscript is not supported by a consistent saved evaluation and requires
a clean rerun. No new model training was performed for this figure update.

\subsection{Model Performance Comparison}

Table~\ref{tab:results} summarizes the test-set performance of all
evaluated models. The threshold-optimized RF substantially outperforms
all other configurations in accuracy, demonstrating that probability
calibration is as important as model architecture for imbalanced
intrusion detection.

\begin{table}[!tbp]
\caption{Originally reported model performance. RF threshold tuning uses the test labels; DNN estimates are unverified.}
\label{tab:results}
\begin{tabular}{lcccc}
\toprule
\textbf{Model} & \textbf{Acc.} & \textbf{AUC} & \textbf{F1-Atk} & \textbf{F1-Nrm} \\
\midrule
RF Default            & 81.13\% & 0.9815 & 0.84 & 0.77 \\
RF Balanced           & 81.29\% & 0.9833 & 0.84 & 0.77 \\
RF + Threshold Tuned  & \textbf{96.87\%} & \textbf{0.9833} & \textbf{0.97} & \textbf{0.96} \\
XGBoost               & 82.00\% & 0.9801 & 0.85 & 0.78 \\
DNN (unverified)      & $\approx$93\%   & $\approx$0.970 & $\approx$0.93 & $\approx$0.93 \\
\bottomrule
\end{tabular}
\end{table}

\subsection{Confusion Matrix Analysis}
\label{sec:diagnostics}

At the default 0.5 threshold, the model misclassifies a significant
portion of attack traffic as normal---a critical failure mode for any
security system. After Youden's~J threshold optimization, the true
positive rate for attack detection increases markedly, with a modest
corresponding increase in false positives. This trade-off is
operationally acceptable: missed attacks pose greater risk than false
alarms in most NIDS deployments.

The following saved outputs are included for traceability, not as
validation of the final model. Figure~\ref{fig:diagnostic-cm} comes from
the early RF run trained with a sliced label vector rather than the
labels aligned to the shuffled training split. Its validation and test
accuracies are 53.85\% and 47.29\%, respectively, and it must not be
presented as a confusion matrix for the 96.87\% threshold-tuned result.

\begin{figure*}[!t]
\centering
\includegraphics[width=0.47\textwidth]{validation_cm.png}\hfill
\includegraphics[width=0.47\textwidth]{test_cm.png}
\caption{Saved early-run validation (left) and test (right) confusion matrices. These diagnose the label-alignment problem and are not the final tuned-model results.}
\Description{Two confusion matrices from an earlier incorrectly aligned-label run, shown solely as diagnostics.}
\label{fig:diagnostic-cm}
\end{figure*}


\subsection{ROC Curve and Threshold Analysis}

The ROC-AUC of 0.9833 for both the balanced RF and the
threshold-optimized RF indicates excellent discriminative ability across
all operating points. The Youden's~J optimal threshold was found to be
significantly below 0.5, confirming that the default threshold
systematically under-detects attacks due to training-set class imbalance.
XGBoost achieved a ROC-AUC of 0.9801, marginally lower than RF despite
employing \texttt{scale\_pos\_weight} compensation.

\subsection{Feature Importance Analysis}

Table~\ref{tab:features} and Figure~\ref{fig:importance} reproduce the
importance ranking saved for the class-balanced RF. Source and
destination bytes rank first and second. The presence of
\texttt{difficulty} in the ranking is a methodological limitation:
it is dataset metadata, not a deployable traffic feature. The ranking
therefore describes this notebook run and should be recomputed after
excluding that column.

\begin{table}[!tbp]
\centering
\caption{Saved RF feature importances from the supplied notebook.}
\label{tab:features}
\begin{tabular}{rlr}
\toprule
Rank & Feature & Importance\\
\midrule
1 & \texttt{src\_bytes} & 0.1733 \\
2 & \texttt{dst\_bytes} & 0.1152 \\
3 & \texttt{flag} & 0.0969 \\
4 & \texttt{difficulty} & 0.0858 \\
5 & \texttt{same\_srv\_rate} & 0.0786 \\
6 & \texttt{dst\_host\_srv\_count} & 0.0592 \\
7 & \texttt{diff\_srv\_rate} & 0.0563 \\
8 & \texttt{dst\_host\_same\_srv\_rate} & 0.0463 \\
9 & \texttt{logged\_in} & 0.0441 \\
10 & \texttt{count} & 0.0398 \\
\bottomrule
\end{tabular}
\end{table}

\begin{figure}[!tbp]
\centering
\includegraphics[width=\linewidth]{feature_importance.png}
\caption{Top ten RF feature importances from the saved notebook run, including the difficulty metadata column.}
\Description{Top ten RF feature importances from the saved notebook run, including the difficulty metadata column.}
\label{fig:importance}
\end{figure}

\subsection{DNN Training Dynamics}

The saved epoch log reaches training accuracy 0.9975 and validation
accuracy 0.9977 at epoch 20. However, the notebook contains inconsistent
target handling and reports test outputs that do not support the original
approximately 93\% claim. The latter remains unverified. The synthetic
dashboard is not used as a DNN training or test-performance figure.
A fresh run with consistent binary labels and separate validation and
test data is required before drawing a generalization conclusion.

%% ==================================================================
\section{Discussion}
%% ==================================================================

\subsection{Interpretation in Context of the Research Gap}

The central finding of this work is that threshold calibration is the
single most impactful intervention available within the current
experimental framework, raising accuracy by over 15 percentage points
compared to the default-threshold baseline while preserving the ROC-AUC.
This directly addresses a practical gap in deployed NIDS: most
operational systems apply fixed decision thresholds without systematic
calibration to specific class distributions.

The large gap between accuracy ($\approx$82\%) and ROC-AUC
($\approx$0.98) for non-tuned models illustrates exactly the failure mode
identified in the research gap: static models with default thresholds
systematically underperform their theoretical potential due to class
imbalance, resulting in high false-negative rates for minority attack
types~\cite{alfawareh2025onoff}.

\subsection{Toward Self-Healing: Architectural Implications}

The empirical results establish a validated detection baseline upon which
the self-healing multi-agent architecture can be constructed. The feature
importance analysis provides a principled feature vocabulary for the LLM
reasoning module: by prioritizing monitoring of byte-count and
connection-rate features, the LLM agent can focus its semantic analysis
on the most informative signal dimensions~\cite{kheddar2025transformers}.

The threshold optimization framework extends naturally to continual
learning: as the network distribution shifts over time, the optimal
threshold can be recalibrated on recent data without retraining the full
model, providing a lightweight adaptation mechanism consistent with the
TAMR approach~\cite{channappayya2023augmented}. The XGBoost model's
marginally lower ROC-AUC compared to RF, despite more complex
hyperparameters, suggests that for the binary detection task on NSL-KDD,
RF provides a better computational efficiency-to-performance
trade-off---relevant for edge deployment in resource-constrained IoT nodes.

\subsection{Limitations}

Several important limitations must be acknowledged. First, NSL-KDD is a
static benchmark that does not capture real-time traffic dynamics;
generalization to live networks requires validation on current corpora
such as CICIoT2023~\cite{neto2023cicion}. Second, binary Normal/Attack
classification discards the granularity of 39 attack subtypes critical
for targeted LLM response generation. Third, the self-healing and
federated components remain architectural proposals not yet empirically
validated. Fourth, the DNN results are reported without exhaustive
hyperparameter search. Finally, adversarial robustness of the trained
models against on-manifold perturbations was not experimentally tested.

%% ==================================================================
\paragraph{Exploratory noise experiment.}
Figure~\ref{fig:perturbation} reproduces the notebook's random uniform
noise experiment. Although its plot title uses ``adversarial,'' the code
does not compute gradients or enforce an on-manifold constraint. The
saved output contains 359 attack samples, whose provenance requires
verification because notebook variables were overwritten in other cells.
The separate smoothing output falls from 68.80\% to 66.30\% at
$\epsilon=0.3$; it does not establish a positive defense recovery.

\begin{figure}[!htbp]
\centering
\includegraphics[width=\linewidth]{perturbation.png}
\caption{Exploratory random-noise sensitivity in the saved notebook: detection rate (left) and misclassification percentage (right). This is not a validated FGSM or on-manifold robustness evaluation.}
\Description{Exploratory random-noise sensitivity in the saved notebook: detection rate (left) and misclassification percentage (right). This is not a validated FGSM or on-manifold robustness evaluation.}
\label{fig:perturbation}
\end{figure}


\section{Conclusion and Future Work}
%% ==================================================================

This paper presented an empirical evaluation of ensemble learning
approaches for binary intrusion detection on the NSL-KDD benchmark
dataset, serving as the validated detection foundation for a proposed
self-healing multi-agent NIDS framework. A rigorous preprocessing
pipeline---comprising categorical encoding, IQR-based outlier capping,
and standard scaling---was applied consistently across all models. Four
classifiers were trained and compared: default RF (81.13\%, AUC 0.9815),
class-balanced RF (81.29\%, AUC 0.9833), threshold-optimized RF
(\textbf{96.87\%}, AUC 0.9833), XGBoost (82.00\%, AUC 0.9801), and a
DNN baseline ($\approx$93\%). Threshold optimization via Youden's~J
statistic yielded the most impactful single improvement, establishing it
as an essential practice for NIDS deployment.

Feature importance analysis identified byte-count, connection-count, and
error-rate features as the most discriminative, providing a principled
vocabulary for future LLM-driven reasoning modules. The experimental
results confirm that ensemble learning with adaptive threshold calibration
constitutes a computationally feasible, high-performance detection layer
upon which the full self-healing framework can be constructed.

Future work will pursue five directions:
\begin{enumerate}
  \item Extend to multi-class classification across all 39 NSL-KDD attack
    subtypes.
  \item Integrate an LLM-driven reasoning module generating natural-language
    incident reports and automated firewall rule suggestions.
  \item Implement and validate the continual learning component with
    TAMR-style memory replay on shifting traffic distributions.
  \item Deploy the framework in a federated setting across simulated IoT
    nodes with non-IID data distributions.
  \item Conduct adversarial robustness evaluation against on-manifold
    attack generation techniques.
\end{enumerate}

%% ==================================================================
%% REFERENCES
%% ==================================================================
\FloatBarrier
\bibliographystyle{ACM-Reference-Format}

\begin{thebibliography}{20}

\bibitem{alfawareh2025onoff}
M.~Al-Fawa'reh, J.~Abu-Khalaf, N.~Janjua, and P.~Szewczyk.
\newblock On and off the manifold: Generation and detection of adversarial
  attacks in IIoT networks.
\newblock \emph{Journal of Network and Computer Applications}, 235:104102, 2025.
\newblock \url{https://doi.org/10.1016/j.jnca.2024.104102}.

\bibitem{ahmed2014gp}
S.~Ahmed, M.~Zhang, and L.~Peng.
\newblock A new GP-based wrapper feature construction approach to
  classification and biomarker identification.
\newblock In \emph{Proc. IEEE Congress on Evolutionary Computation (CEC)},
  pages 2756--2763, 2014.
\newblock \url{https://doi.org/10.1109/CEC.2014.6900317}.

\bibitem{shukla2023uindesi}
A.~K.~Shukla, S.~Srivastav, S.~Kumar, and P.~K.~Muhuri.
\newblock UInDeSI4.0: An efficient unsupervised intrusion detection system
  for network traffic flow in Industry~4.0.
\newblock \emph{Engineering Applications of Artificial Intelligence},
  120:1--9, 2023.
\newblock \url{https://doi.org/10.1016/j.engappai.2023.105848}.

\bibitem{agrawal2022federated}
S.~Agrawal et al.
\newblock Federated learning for intrusion detection system: Concepts,
  challenges and future directions.
\newblock \emph{Computer Communications}, 195:346--361, 2022.
\newblock \url{https://doi.org/10.1016/j.comcom.2022.09.012}.

\bibitem{bangui2022hybrid}
H.~Bangui, M.~Ge, and B.~Buhnova.
\newblock A hybrid machine learning model for intrusion detection in VANET.
\newblock \emph{Computing}, 104(3):503--531, 2022.
\newblock \url{https://doi.org/10.1007/s00607-021-01001-0}.

\bibitem{berardi2023operation}
D.~Berardi et al.
\newblock When operation technology meets information technology: Challenges
  and opportunities.
\newblock \emph{Future Internet}, 15(3), 2023.
\newblock \url{https://doi.org/10.3390/fi15030095}.

\bibitem{attaran2024digital}
S.~Attaran, M.~Attaran, and B.~G.~Celik.
\newblock Digital twins and Industrial Internet of Things: Uncovering
  operational intelligence in Industry~4.0.
\newblock \emph{Decision Analytics Journal}, 10:100398, 2024.
\newblock \url{https://doi.org/10.1016/j.dajour.2024.100398}.

\bibitem{yin2017deep}
C.~Yin, Y.~Zhu, J.~Fei, and X.~He.
\newblock A deep learning approach for intrusion detection using recurrent
  neural networks.
\newblock \emph{IEEE Access}, 5:21954--21961, 2017.
\newblock \url{https://doi.org/10.1109/ACCESS.2017.2762418}.

\bibitem{dong2019survey}
S.~Dong, K.~Abbas, and R.~Jain.
\newblock A survey on distributed denial of service (DDoS) attacks in SDN
  and cloud computing environments.
\newblock \emph{IEEE Access}, 7:80813--80828, 2019.
\newblock \url{https://doi.org/10.1109/ACCESS.2019.2922196}.

\bibitem{ahmad2021anomaly}
Z.~Ahmad et al.
\newblock Anomaly detection using deep neural network for IoT architecture.
\newblock \emph{Applied Sciences}, 11(15), 2021.
\newblock \url{https://doi.org/10.3390/app11157050}.

\bibitem{kheddar2025transformers}
H.~Kheddar.
\newblock Transformers and large language models for efficient intrusion
  detection systems: A comprehensive survey.
\newblock \emph{Information Fusion}, 124:103347, 2025.
\newblock \url{https://doi.org/10.48550/arXiv.2408.07583}.

\bibitem{folino2023ensemble}
G.~Folino, C.~O.~Godano, and F.~S.~Pisani.
\newblock An ensemble-based framework for user behaviour anomaly detection
  and classification for cybersecurity.
\newblock \emph{Journal of Supercomputing}, 79(11):11660--11683, 2023.
\newblock \url{https://doi.org/10.1007/s11227-023-05049-x}.

\bibitem{sun2024gnnids}
Z.~Sun, A.~M.~H.~Teixeira, and S.~Toor.
\newblock GNN-IDS: Graph neural network based intrusion detection system.
\newblock In \emph{Proc. 19th International Conference on Availability,
  Reliability and Security}, pages 1--12, 2024.
\newblock \url{https://doi.org/10.1145/3664476.366451}.

\bibitem{neto2023cicion}
E.~C.~P.~Neto et al.
\newblock CICIoT2023: A real-time dataset and benchmark for large-scale
  attacks in IoT environment.
\newblock \emph{Sensors}, 23(13):5941, 2023.
\newblock \url{https://doi.org/10.3390/s23135941}.

\bibitem{channappayya2023augmented}
S.~Channappayya et al.
\newblock Augmented memory replay-based continual learning approaches for
  network intrusion detection.
\newblock \emph{Advances in Neural Information Processing Systems},
  36:17156--17169, 2023.
\newblock \url{https://doi.org/10.5555/3666122.3666872}.

\bibitem{masud2025explainable}
M.~T.~Masud et al.
\newblock Explainable artificial intelligence for resilient security
  applications in the Internet of Things.
\newblock \emph{IEEE Open Journal of the Communications Society},
  6:2877--2906, 2025.
\newblock \url{https://doi.org/10.1109/OJCOMS.2024.3413790}.

\bibitem{zhang2020unknown}
Z.~Zhang, Q.~Liu, S.~Qiu, S.~Zhou, and C.~Zhang.
\newblock Unknown attack detection based on zero-shot learning.
\newblock \emph{IEEE Access}, 8:193981--193991, 2020.
\newblock \url{https://doi.org/10.1109/ACCESS.2020.3033494}.

\bibitem{yang2019building}
Y.~Yang, K.~Zheng, C.~Wu, X.~Niu, and Y.~Yang.
\newblock Building an effective intrusion detection system using the modified
  density peak clustering algorithm and deep belief networks.
\newblock \emph{Applied Sciences}, 9(2):238, 2019.
\newblock \url{https://doi.org/10.3390/app9020238}.

\bibitem{jiang2022graph}
W.~Jiang.
\newblock Graph-based deep learning for communication networks: A survey.
\newblock \emph{Computer Communications}, 185:40--54, 2022.
\newblock \url{https://doi.org/10.1016/j.comcom.2021.12.015}.

\bibitem{kavre2019iot}
M.~Kavre, A.~Gadekar, and Y.~Gadhade.
\newblock Internet of Things (IoT): A survey.
\newblock In \emph{Proc. IEEE Pune Section International Conference},
  pages 1--6, 2019.
\newblock \url{https://doi.org/10.1109/PuneCon46936.2019.9105831}.

\end{thebibliography}


\end{document}

LaTeX paper with original Colab figures

Main file: B_Group11_Paper_with_figures.tex
Upload the main file and the entire figures directory to Overleaf.
Use pdfLaTeX and the ACM acmart class (available in Overleaf).
Compile twice for references. No external .bib file is required.

The original manuscript source and bibliography were preserved, with
figure references, captions, an evaluation-status paragraph, corrected
feature-importance values, a wrapped DNN equation, and diagnostic material in its relevant Results and Limitations sections.
10 PNG assets are included in 9 numbered figure environments.

Important source inconsistencies are identified in the paper:
- The 96.87% threshold result was tuned on test labels (threshold 0.0350).
- Earlier confusion matrices use an incorrectly aligned training-label run.
- The feature ranking includes difficulty metadata as a predictor.
- The DNN estimate is unverified; its saved evaluations disagree.
- Random uniform noise is not FGSM or an on-manifold attack.
- Summary dashboards contain synthetic or manually entered values and are omitted.
The original literature and other manuscript claims were not independently audited.
No models were rerun, and no credentials or notebook setup cells are included.

Compilation status: The built-in compiler could not initialize (Unable to find standard directories for platform). PDF compilation and final page layout have not been verified. All image assets and LaTeX cross-references were checked.

Placement update: Confusion matrices are in Confusion Matrix Analysis; the random-noise experiment is in Limitations. Figures are anchored beside their relevant source sections and may float to the next suitable page. References are last; no appendix follows them.

Compact layout revision: Removed subsection float barriers responsible for nearly empty pages; enabled mixed text/figure pages, reduced float spacing and pie-chart size, and balanced the final reference columns. One barrier remains before References. Final PDF layout still requires compilation.
