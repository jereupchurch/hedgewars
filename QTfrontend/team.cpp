/*
 * Hedgewars, a worms-like game
 * Copyright (c) 2005, 2006 Andrey Korotaev <unC0Rr@gmail.com>
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

#include <QFile>
#include <QTextStream>
#include <QApplication>
#include "team.h"
#include "hwform.h"
#include "predefteams.h"
#include "pages.h"
#include "hwconsts.h"

HWTeam::HWTeam(const QString & teamname)
{
	TeamName = teamname;
	for (int i = 0; i < 8; i++) HHName[i].sprintf("hedgehog %d", i);
	Grave = "Simple";
	Fort = "Barrelhouse";
	for(int i = 0; i < BINDS_NUMBER; i++)
	{
		binds[i].action = cbinds[i].action;
		binds[i].strbind = cbinds[i].strbind;
	}
}

HWTeam::HWTeam(quint8 num)
{
	num %= PREDEFTEAMS_COUNT;
	TeamName = QApplication::translate("teams", pteams[num].TeamName);
	HHName[0] = QApplication::translate("teams", pteams[num].hh0name);
	HHName[1] = QApplication::translate("teams", pteams[num].hh1name);
	HHName[2] = QApplication::translate("teams", pteams[num].hh2name);
	HHName[3] = QApplication::translate("teams", pteams[num].hh3name);
	HHName[4] = QApplication::translate("teams", pteams[num].hh4name);
	HHName[5] = QApplication::translate("teams", pteams[num].hh5name);
	HHName[6] = QApplication::translate("teams", pteams[num].hh6name);
	HHName[7] = QApplication::translate("teams", pteams[num].hh7name);
	Grave = pteams[num].Grave;
	Fort = pteams[num].Fort;
	for(int i = 0; i < BINDS_NUMBER; i++)
	{
		binds[i].action = cbinds[i].action;
		binds[i].strbind = cbinds[i].strbind;
	}
}


bool HWTeam::LoadFromFile()
{
	QFile cfgfile(cfgdir->absolutePath() + "/" + TeamName + ".cfg");
	if (!cfgfile.open(QIODevice::ReadOnly)) return false;
	QTextStream stream(&cfgfile);
	stream.setCodec("UTF-8");
	QString str;
	QString action;

	while (!stream.atEnd())
	{
		str = stream.readLine();
		if (str.startsWith(";")) continue;
		if (str.startsWith("name team "))
		{
			str.remove(0, 10);
			TeamName = str;
		} else
		if (str.startsWith("name hh"))
		{
			str.remove(0, 7);
			long i = str.left(1).toLong();
			if ((i < 0) || (i > 7)) continue;
			str.remove(0, 2);
			HHName[i] = str;
		} else
		if (str.startsWith("grave "))
		{
			str.remove(0, 6);
			Grave = str;
		} else
		if (str.startsWith("fort "))
		{
			str.remove(0, 5);
			Fort = str;
		} else
		if (str.startsWith("bind "))
		{
			str.remove(0, 5);
			action = str.section(' ', 1);
			str = str.section(' ', 0, 0);
			str.truncate(15);
			for (int i = 0; i < BINDS_NUMBER; i++)
				if (action == binds[i].action)
				{
					binds[i].strbind = str;
					break;
				}
		}
	}
	cfgfile.close();
	return true;
}

bool HWTeam::SaveToFile()
{
	QFile cfgfile(cfgdir->absolutePath() + "/" + TeamName + ".cfg");
	if (!cfgfile.open(QIODevice::WriteOnly)) return false;
	QTextStream stream(&cfgfile);
	stream.setCodec("UTF-8");
	stream << "; Generated by Hedgewars, do not modify" << endl;
	stream << "name team " << TeamName << endl;
	for (int i = 0; i < 8; i++)
		stream << "name hh" << i << " " << HHName[i] << endl;
	stream << "grave " << Grave << endl;
	stream << "fort " << Fort << endl;
	for(int i = 0; i < BINDS_NUMBER; i++)
	{
		stream << "bind " << binds[i].strbind << " " << binds[i].action << endl;
	}
	cfgfile.close();
	return true;
}

void HWTeam::SetToPage(HWForm * hwform)
{
	hwform->ui.pageEditTeam->TeamNameEdit->setText(TeamName);
	for(int i = 0; i < 8; i++)
	{
		hwform->ui.pageEditTeam->HHNameEdit[i]->setText(HHName[i]);
	}
	hwform->ui.pageEditTeam->CBGrave->setCurrentIndex(hwform->ui.pageEditTeam->CBGrave->findText(Grave));
	hwform->ui.pageEditTeam->CBGrave_activated(Grave);

	hwform->ui.pageEditTeam->CBFort->setCurrentIndex(hwform->ui.pageEditTeam->CBFort->findText(Fort));
	hwform->ui.pageEditTeam->CBFort_activated(Fort);

	for(int i = 0; i < BINDS_NUMBER; i++)
	{
		hwform->ui.pageEditTeam->CBBind[i]->setCurrentIndex(hwform->ui.pageEditTeam->CBBind[i]->findText(binds[i].strbind));
	}
}

void HWTeam::GetFromPage(HWForm * hwform)
{
	TeamName  = hwform->ui.pageEditTeam->TeamNameEdit->text();
	for(int i = 0; i < 8; i++)
	{
		HHName[i] = hwform->ui.pageEditTeam->HHNameEdit[i]->text();
	}

	Grave = hwform->ui.pageEditTeam->CBGrave->currentText();
	Fort = hwform->ui.pageEditTeam->CBFort->currentText();
	for(int i = 0; i < 8; i++)
	{
		binds[i].strbind = hwform->ui.pageEditTeam->CBBind[i]->currentText();
	}
}

QByteArray HWTeam::IPCTeamInfo() const
{
	QByteArray buf;
	#define ADD(a) { \
					QByteArray strmsg = a.toUtf8(); \
					quint8 sz = strmsg.size(); \
					buf.append(QByteArray((char *)&sz, 1)); \
					buf.append(strmsg); \
					}

	ADD(QString("ename team " + TeamName));
	for (int i = 0; i < 8; i++)
		ADD(QString("ename hh%1 ").arg(i).append(HHName[i]));
	ADD(QString("egrave " + Grave));
	ADD(QString("efort " + Fort));
	for(int i = 0; i < BINDS_NUMBER; i++)
	{
		ADD(QString("ebind " + binds[i].strbind + " " + binds[i].action));
	}
	#undef ADD
	return buf;
}

bool HWTeam::operator==(const HWTeam& t1) const {
  return TeamName==t1.TeamName;
}

bool HWTeam::operator<(const HWTeam& t1) const {
  return TeamName<t1.TeamName;
}
