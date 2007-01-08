/*
 * Hedgewars, a worms-like game
 * Copyright (c) 2006 Andrey Korotaev <unC0Rr@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#include <QResizeEvent>
#include <QGroupBox>
#include <QCheckBox>
#include <QGridLayout>
#include <QSpinBox>
#include <QLabel>
#include "gamecfgwidget.h"

GameCFGWidget::GameCFGWidget(QWidget* parent) :
  QWidget(parent), mainLayout(this)
{
	mainLayout.setMargin(0);
	QGroupBox *GBoxMap = new QGroupBox(this);
	GBoxMap->setTitle(QGroupBox::tr("Landscape"));
	GBoxMap->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
	mainLayout.addWidget(GBoxMap);

	QHBoxLayout *GBoxMapLayout = new QHBoxLayout(GBoxMap);
	GBoxMapLayout->setMargin(0);
	pMapContainer = new HWMapContainer(GBoxMap);
	GBoxMapLayout->addWidget(new QWidget);
	GBoxMapLayout->addWidget(pMapContainer);
	GBoxMapLayout->addWidget(new QWidget);

	QGroupBox *GBoxOptions = new QGroupBox(this);
	GBoxOptions->setTitle(QGroupBox::tr("Game scheme"));
	GBoxOptions->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);
	mainLayout.addWidget(GBoxOptions);

	QGridLayout *GBoxOptionsLayout = new QGridLayout(GBoxOptions);
	CB_mode_Forts = new QCheckBox(GBoxOptions);
	CB_mode_Forts->setText(QCheckBox::tr("Forts mode"));
	GBoxOptionsLayout->addWidget(CB_mode_Forts, 0, 0, 1, 2);

	L_TurnTime = new QLabel(QLabel::tr("Turn time"), GBoxOptions);
	L_InitHealth = new QLabel(QLabel::tr("Initial health"), GBoxOptions);
	GBoxOptionsLayout->addWidget(L_TurnTime, 1, 0);
	GBoxOptionsLayout->addWidget(L_InitHealth, 2, 0);

	SB_TurnTime = new QSpinBox(GBoxOptions);
	SB_TurnTime->setRange(15, 90);
	SB_TurnTime->setValue(45);
	SB_TurnTime->setSingleStep(15);
	SB_InitHealth = new QSpinBox(GBoxOptions);
	SB_InitHealth->setRange(50, 200);
	SB_InitHealth->setValue(100);
	SB_InitHealth->setSingleStep(25);
	GBoxOptionsLayout->addWidget(SB_TurnTime, 1, 1);
	GBoxOptionsLayout->addWidget(SB_InitHealth, 2, 1);

	mainLayout.addWidget(new QWidget, 100);
}

quint32 GameCFGWidget::getGameFlags()
{
	quint32 result = 0;
	if (CB_mode_Forts->isChecked())
		result |= 1;
	return result;
}

QString GameCFGWidget::getCurrentSeed() const
{
  return pMapContainer->getCurrentSeed();
}

QString GameCFGWidget::getCurrentMap() const
{
  return pMapContainer->getCurrentMap();
}

QString GameCFGWidget::getCurrentTheme() const
{
  return pMapContainer->getCurrentTheme();
}

quint32 GameCFGWidget::getInitHealth() const
{
	return SB_InitHealth->value();
}

quint32 GameCFGWidget::getTurnTime() const
{
	return SB_TurnTime->value();
}
