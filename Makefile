
TARGET_DIR=,,usage-charts
stopped_files:=$(wildcard stopped/*)
concept_files:=$(wildcard concept-*.txt)
concepts:=$(concept_files:concept-%.txt=%)
target_word_pairs:= \
    trade-protestant \
    state-church \
    arbitrary_power-common_law \
    popery-protestant \
    church-trade \
    protestant-state \
    rebellion-parliament \
    parliament-state \
    common_law-protestant \
    subject-arbitrary_power \
    superstition-fanaticism
target_word_triples:= coke-trade-common_law
target_concept_pairs:= \
    trade-toleration \
    trade-intolerance \
    toleration-intolerance

target_words:= \
act_parliament \
ancient_constitution \
arbitrary_power \
bigamy \
christian_people \
church \
church_state \
coke \
common_law \
cromwell \
dominion \
ecclesiastical_affairs \
ecclesiastical_polity \
ecclesiastical_power \
english_constitution \
enthusiasm \
equity \
established_church \
fanaticism \
hereditary \
hereditary_right \
high_treason \
kingdom \
kings?_conscience \
kings?_prerogative \
libel \
loyal_subject \
murder \
national_interest \
natural_liberty \
natural_religion \
oates \
obedient_subject \
parliament \
popery \
popish_priest \
popularity \
population \
princely_care \
protestant \
protestant_faith \
public_good \
public_mind \
public_opinion \
rebellion \
rebellion \
roman_catholic \
scandalous_libels \
schizmatics \
state \
subject \
superstition \
tariff \
tax(es)? \
trade

goal_files:= \
	$(concepts:%=$(TARGET_DIR)/concept-%.pdf) \
	$(target_words:%=$(TARGET_DIR)/%.pdf) \
	$(target_word_pairs:%=$(TARGET_DIR)/pair-%.pdf) \
	$(target_word_triples:%=$(TARGET_DIR)/triple-%.pdf) \
	$(target_concept_pairs:%=$(TARGET_DIR)/pair-concept-%.pdf)

unescape=$(subst _, ,$(1))
fword=$(firstword $(subst -, ,$(1)))
sword=$(word 2,$(subst -, ,$(1)))
tword=$(word 3,$(subst -, ,$(1)))

.SECONDARY: $(goal_files:.pdf=.csv)

$(TARGET_DIR)/concept-%.csv: concept-%.txt phrase-usage.py case-year.csv $(stopped_files)
	./phrase-usage.py @$< case-year.csv $(stopped_files) > $@

$(TARGET_DIR)/concept-%.pdf: $(TARGET_DIR)/concept-%.csv chart-concept.gnuplot
	cd $(TARGET_DIR) && gnuplot -e "concept=\"$*\"" ../chart-concept.gnuplot

$(TARGET_DIR)/pair-concept-%.pdf: pair-concept-chart.gnuplot
	cd $(TARGET_DIR) && gnuplot -e "concepta=\"$(call unescape,$(call fword,$*))\";conceptb=\"$(call unescape,$(call sword,$*))\"" ../pair-concept-chart.gnuplot

$(TARGET_DIR)/pair-%.pdf: pair-chart.gnuplot
	cd $(TARGET_DIR) && gnuplot -e "worda=\"$(call fword,$*)\";wordb=\"$(call sword,$*)\"" ../pair-chart.gnuplot

$(TARGET_DIR)/triple-%.pdf: triple-chart.gnuplot
	cd $(TARGET_DIR) && gnuplot -e "worda=\"$(call fword,$*)\";wordb=\"$(call sword,$*)\";wordc=\"$(call tword,$*)\"" ../triple-chart.gnuplot

$(TARGET_DIR)/%.csv: phrase-usage.py case-year.csv $(stopped_files)
	./phrase-usage.py "$(call unescape,$*)" case-year.csv $(stopped_files) > "$(TARGET_DIR)/$*.csv"

$(TARGET_DIR)/%.pdf: $(TARGET_DIR)/%.csv usage-chart.gnuplot
	cd $(TARGET_DIR) && gnuplot -e "word=\"$*\"" ../usage-chart.gnuplot

all: $(goal_files)


$(TARGET_DIR)/pair-church-state.pdf: $(TARGET_DIR)/church.csv $(TARGET_DIR)/state.csv
$(TARGET_DIR)/pair-trade-protestant.pdf: $(TARGET_DIR)/trade.csv $(TARGET_DIR)/protestant.csv
$(TARGET_DIR)/pair-state-church.pdf: $(TARGET_DIR)/state.csv $(TARGET_DIR)/church.csv
$(TARGET_DIR)/pair-arbitrary_power-common_law.pdf: $(TARGET_DIR)/arbitrary_power.csv $(TARGET_DIR)/common_law.csv
$(TARGET_DIR)/pair-popery-protestant.pdf: $(TARGET_DIR)/popery.csv $(TARGET_DIR)/protestant.csv
$(TARGET_DIR)/pair-church-trade.pdf: $(TARGET_DIR)/church.csv $(TARGET_DIR)/trade.csv
$(TARGET_DIR)/pair-protestant-state.pdf: $(TARGET_DIR)/protestant.csv $(TARGET_DIR)/state.csv
$(TARGET_DIR)/pair-rebellion-parliament.pdf: $(TARGET_DIR)/rebellion.csv $(TARGET_DIR)/parliament.csv
$(TARGET_DIR)/pair-parliament-state.pdf: $(TARGET_DIR)/parliament.csv $(TARGET_DIR)/state.csv
$(TARGET_DIR)/pair-common_law-protestant.pdf: $(TARGET_DIR)/common_law.csv $(TARGET_DIR)/protestant.csv
$(TARGET_DIR)/pair-subject-arbitrary_power.pdf: $(TARGET_DIR)/subject.csv $(TARGET_DIR)/arbitrary_power.csv
$(TARGET_DIR)/pair-superstition-fanaticism.pdf: $(TARGET_DIR)/superstition.csv $(TARGET_DIR)/fanaticism.csv

$(TARGET_DIR)/triple-coke-trade-common_law.pdf: $(addprefix $(TARGET_DIR)/,coke.csv trade.csv common_law.csv)

$(TARGET_DIR)/pair-concept-trade-toleration.pdf: $(addprefix $(TARGET_DIR)/concept-,trade.csv toleration.csv)
$(TARGET_DIR)/pair-concept-trade-intolerance.pdf: $(addprefix $(TARGET_DIR)/concept-,trade.csv intolerance.csv)
$(TARGET_DIR)/pair-concept-toleration-intolerance.pdf: $(addprefix $(TARGET_DIR)/concept-,toleration.csv intolerance.csv)
