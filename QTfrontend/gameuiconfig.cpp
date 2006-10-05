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

#include <QMessageBox>
#include <QTextStream>
#include "gameuiconfig.h"
#include "hwform.h"
#include "pages.h"
#include "hwconsts.h"

GameUIConfig::GameUIConfig(HWForm * FormWidgets)
	: QObject()
{
	Form = FormWidgets;

	QFile settings(cfgdir->absolutePath() + "/options");
	if (settings.open(QIODevice::ReadOnly))
	{
		QTextStream stream(&settings);
		stream.setCodec("UTF-8");
		QString str;

		while (!stream.atEnd())
		{
			str = stream.readLine();
			if (str.startsWith(";")) continue;
			if (str.startsWith("resolution "))
			{
				Form->ui.pageOptions->CBResolution->setCurrentIndex(str.mid(11).toLong());
			} else
			if (str.startsWith("fullscreen "))
			{
				Form->ui.pageOptions->CBFullscreen->setChecked(str.mid(11).toLong());
			} else
			if (str.startsWith("sound "))
			{
				Form->ui.pageOptions->CBEnableSound->setChecked(str.mid(6).toLong());
			} else
			if (str.startsWith("nick "))
			{
				Form->ui.pageNet->editNetNick->setText(str.mid(5));
			} else
			if (str.startsWith("ip "))
			{
				Form->ui.pageNet->editIP->setText(str.mid(3));
			}
		}
		settings.close();
	}

	QFile themesfile(datadir->absolutePath() + "/Themes/themes.cfg");
	if (themesfile.open(QIODevice::ReadOnly)) {
		QTextStream stream(&themesfile);
		QString str;
		while (!stream.atEnd())
		{
			Themes << stream.readLine();
		}
		themesfile.close();
	} else {
		QMessageBox::critical(0, "Error", "Cannot access themes.cfg", "OK");
	}
}

QStringList GameUIConfig::GetTeamsList()
{
	QStringList teamslist = cfgdir->entryList(QStringList("*.cfg"));
	QStringList cleanedList;
	for (QStringList::Iterator it = teamslist.begin(); it != teamslist.end(); ++it ) {
	  QString tmpTeamStr=(*it).replace(QRegExp("^(.*).cfg$"), "\\1");
	  cleanedList.push_back(tmpTeamStr);
	}
	return cleanedList;
}

void GameUIConfig::SaveOptions()
{
	QFile settings(cfgdir->absolutePath() + "/options");
	if (!settings.open(QIODevice::WriteOnly))
	{
		QMessageBox::critical(0,
				tr("Error"),
				tr("Cannot save options to file %1").arg(settings.fileName()),
				tr("Quit"));
		return ;
	}
	QTextStream stream(&settings);
	stream.setCodec("UTF-8");
	stream << "; Generated by Hedgewars, do not modify" << endl;
	stream << "resolution " << Form->ui.pageOptions->CBResolution->currentIndex() << endl;
	stream << "fullscreen " << Form->ui.pageOptions->CBFullscreen->isChecked() << endl;
	stream << "sound " << Form->ui.pageOptions->CBEnableSound->isChecked() << endl;
	stream << "nick " << Form->ui.pageNet->editNetNick->text() << endl;
	stream << "ip " << Form->ui.pageNet->editIP->text() << endl;
	settings.close();
}

int GameUIConfig::vid_Resolution()
{
	return Form->ui.pageOptions->CBResolution->currentIndex();
}

bool GameUIConfig::vid_Fullscreen()
{
	return Form->ui.pageOptions->CBFullscreen->isChecked();
}

bool GameUIConfig::isSoundEnabled()
{
	return Form->ui.pageOptions->CBEnableSound->isChecked();
}

QString GameUIConfig::GetRandomTheme()
{
	return (Themes.size() > 0) ? Themes[rand() % Themes.size()] : QString("steel");
}
